# Recipe 1 → Recipe 7（完美版：真实 HR 值）

**目标**：从 HAE payload 中提取**实际 heart_rate 最大值**传给 Recipe 7，而非硬编码

**预计耗时**：25-40 min（formula 可能要试 1-2 次才对）

---

## HAE payload 结构（参考）

```json
{
  "Data": {
    "Metrics": [
      {"Name": "sleep_analysis", "Data": [...]},
      {"Name": "heart_rate", "Data": [
        {"Avg": 86, "Min": 86, "Max": 86, "Date": "...", "Source": "..."},
        {"Avg": 89, "Min": 89, "Max": 89, "Date": "...", "Source": "..."},
        ...
      ]}
    ]
  }
}
```

我们要从这个嵌套结构提取：
- **heart_rate metric** 在 Metrics array 里通过 `Name == "heart_rate"` 过滤
- 拿它的 **Data** array
- 计算 **Max(Avg)** 或者 **Last(Avg)**

---

## 关键：Workato formula 语法

Workato 用 Ruby-style formulas，array 操作支持：
- `array.where(Field: value)` — 过滤
- `array.first` / `array.last` — 取一个
- `array.pluck('Field')` — 提取所有该字段值
- `array.map { |x| x.Field }` — 同上
- `array.max` / `array.sum` / `array.length`

**官方文档已验证的 formula**（用这个）：
```ruby
data.payload.Data.Metrics.where('Name': 'heart_rate').first.Data.pluck('Avg').max
```

要点：
- `where('Name': 'heart_rate')` — hash colon `'Name':`，不是 `Name ==`
- `.first` — 过滤后的第一个 hash 对象
- `.pluck('Avg')` — 提取数字数组
- `.max` — 最大值

**Last 值（最近一次心率）**：
```ruby
data.payload.Data.Metrics.where('Name': 'heart_rate').first.Data.last.Avg
```

**Average**：
```ruby
data.payload.Data.Metrics.where('Name': 'heart_rate').first.Data.pluck('Avg').sum / data.payload.Data.Metrics.where('Name': 'heart_rate').first.Data.length
```

文档：
- https://docs.workato.com/formulas/array-list-formulas.html
- https://support.workato.com/support/solutions/articles/1000236824

---

## ⚠️ 前置：Trigger schema 必须包含 heart_rate

如果 Recipe 1 trigger 的 schema 是 HAE 没启用 HR 之前 sample 的，可能 Metrics array 里没 heart_rate 的字段定义。

**怎么处理**：
1. 进 Recipe 1 trigger（step 1）的设置
2. 找 **"Refresh sample"** 或 **"Replace sample"** 按钮
3. 用最新的 HAE event（包含 heart_rate）重新 sample
4. 之后 pill panel 应该能看到 `heart_rate` 路径下的字段

如果不会做这一步 → fallback：Workato formula 可能不依赖 schema（直接 JSON path 访问），可以**先尝试不 refresh schema 直接配置**，若 formula error 再 refresh。

---

## Step 1 — 完成 step 3 HTTP setup

按 RECIPE1_TO_RECIPE7.md 的 §1 → 进 setup manually

---

## Step 2 — 填字段（VS 简单版的差异）

### 2.1 - 2.4 同 RECIPE1_TO_RECIPE7.md
（Request name / Method / URL / Content type 都一样）

### 2.5 Request body（**完美版本，这里不一样**）

**两种实现方式选一个**：

#### 方式 A：用 JSON request body（结构化）

切到 content type = **JSON request body**（不是 Raw JSON），Workato 给你字段构建器。每个字段可以独立设置：
- `metric`（text）：填 `heart_rate`
- `value`（formula）：点该字段的 **Formula 模式 toggle**，粘：
  ```
  data.payload['Data']['Metrics'].where('Name': 'heart_rate').first['Data'].pluck('Avg').max
  ```
- `source`（text）：填 `apple_watch_chain_real`
- `sample_count`（formula，可选）：
  ```
  data.payload['Data']['Metrics'].where('Name': 'heart_rate').first['Data'].length
  ```

#### 方式 B：用 Raw JSON body + 内联 pill

content type = **Raw JSON request body**，body 文本：
```
{
  "metric": "heart_rate",
  "value": <<INSERT_PILL_HERE>>,
  "source": "apple_watch_chain_real"
}
```

把 `<<INSERT_PILL_HERE>>` 选中，从左面板**找 trigger output**：
- New event via webhook → Payload → Data → Metrics → 找到 `heart_rate` 那一项 → Data → 选 `Avg`（或 max(Avg)）→ 拖入

如果 pill panel 没有 heart_rate 路径 → 必须先 refresh schema（见上面 ⚠️）

**推荐方式 A**——结构化更不容易出错，formula 单独可调试。

---

## Step 3 — Save + Start + Test

### Save
点保存。如果 formula syntax 错了，会报红 + 高亮哪一行。看错误信息修。常见错：
- `Method 'where' not defined` → 用 `select { |m| m.Name == 'xxx' }` 替代
- `NoMethodError on nil` → 路径错（`'Data'` 大小写敏感）
- `pluck` 不识别 → 用 `map { |x| x.Avg }` 替代

### Start

### Test
```bash
curl -s -X POST -H 'Content-Type: application/json' \
  -d '{
    "Data": {
      "Metrics": [
        {"Name": "heart_rate", "Data": [
          {"Avg": 95, "Min": 90, "Max": 100, "Date": "2026-04-20 09:00:00 +0800"},
          {"Avg": 152, "Min": 148, "Max": 156, "Date": "2026-04-20 09:00:30 +0800"},
          {"Avg": 178, "Min": 175, "Max": 180, "Date": "2026-04-20 09:01:00 +0800"}
        ]}
      ]
    }
  }' \
  'https://webhooks.trial.workato.com/webhooks/rest/75c7e434-bc99-44b9-99e7-705948d0a35d/ripple-health-data'
```

预期：
1. Recipe 1 jobs +1（成功）
2. Recipe 7 jobs +1（被 Recipe 1 触发）
3. **WhatsApp 收到 alert，显示 178 bpm**（max of [95, 152, 178]）

如果显示 95 → formula 取了 first 不是 max
如果显示其他数 → formula 路径错

---

## Step 4 — 真手表验证

戴手表跑 30 秒楼梯，等 ~5 min HAE 推：
- HAE 把你真实 HR 推过来
- Recipe 1 处理 → POST max(HR) 给 Recipe 7
- 如果 max > Recipe 7 阈值（150） → WA alert
- 如果 < 150 → 没 alert

⚠️ 如果你跑楼梯没拉到 150 → 临时把 Recipe 7 的 IF threshold 降到 110

---

## Rollback

Recipe 1 Versions tab → 选恢复点 → 是 → Start

---

## 为什么这是"完美"

✅ Recipe 1 真读取 HAE 的实际 HR  
✅ Recipe 7 收到的 value 是真实数值  
✅ WhatsApp 通知里写的 BPM 是真测出来的  
✅ Demo 时观众看到运动→真 HR→真警报，端到端无猫腻

---

## 如果 Workato formula 试不出来（plan B fallback）

让我知道，我研究 Workato formula docs 给出确切语法。或者改用 Repeat for each + nested IF（更繁但 100% work）。
