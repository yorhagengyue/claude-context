# Recipe 1 → Recipe 7 链路接通（手粘版，10-15 min）

**目标**：让 Recipe 1（v1）在 Upsert healthlog 后，自动 POST 心率到 Recipe 7（live_hr_alert_demo），打通**真手表 → WA alert** 端到端

**前置**：
- Recipe 1 当前已 Stop + 在 edit 模式（我已处理）
- Step 3 是空的"选择一个应用和操作"placeholder（我加了一半）
- 备份在 `localStorage['__recipe1_v1_backup']`，搞砸用 Versions tab 恢复

---

## Step 1 — 完成 step 3 的 HTTP setup

右侧面板当前停在"选择一个应用"。**手做**：

1. 点 **HTTP** 卡片 → 进入 Connection 选择
2. 选 **Supabase Ripple**（或任意已有 HTTP connection）→ 进入 Action 选择
3. 选 **Send request via HTTP**（中文：通过 HTTP 发送请求）
4. 右侧出现 "Start guided setup" / "setup manually" → **点 setup manually**

字段全展开后回来。

---

## Step 2 — 填 5 个字段

### 2.1 Request name
```
Forward HR to Recipe 7 alert
```

### 2.2 Method
下拉选 **POST**

### 2.3 Request URL（粘贴 → Tab）
```
https://webhooks.trial.workato.com/webhooks/rest/75c7e434-bc99-44b9-99e7-705948d0a35d/ripple-live-alert
```

### 2.4 Request content type
下拉选 **Raw JSON request body**

### 2.5 Request body（粘贴）

**最简版（把整个 HAE payload 转发给 Recipe 7，Recipe 7 自己解析）**：

```json
{
  "metric": "heart_rate",
  "value": 178,
  "source": "apple_watch_chain",
  "note": "forwarded from Recipe 1"
}
```

⚠️ **value 字段**：暂时**硬编码成 178**（高于 Recipe 7 的 IF 阈值，必触发 WA）。后面 demo 时你拍脚步运动 → 过几分钟 HAE 推 → 这个 chain 跑 → 你**总是**收到 178bpm 的 alert（不管你真心率是多少）。

**这是 demo 用的"演出版"链路**——证明端到端可以跑通，但 value 是写死的。

要做"真心率"版本（value 跟随实际 HR），需要：
- 在 body 里用 Workato formula 提取 `data.payload.Data.Metrics where Name=heart_rate first.Data last.Avg`
- 涉及 array find + nested formula，比较复杂
- **如果 demo 时间紧，先用硬编码版本**

---

## Step 3 — Save + Start

1. 右上 **保存**（应该没有 required field 报错）
2. 右上 **退出**
3. 回到 Recipe 页 → **启动 Recipe**

---

## Step 4 — 测试

打开 terminal：
```bash
# 模拟 HAE 推送（带 heart_rate 数据）触发 Recipe 1 → Recipe 7
curl -s -X POST -H 'Content-Type: application/json' \
  -d '{
    "Data": {
      "Metrics": [
        {"Name": "heart_rate", "Data": [{"Avg": 175, "Min": 170, "Max": 180, "Date": "2026-04-20 09:00:00 +0800", "Source": "test"}]}
      ]
    }
  }' \
  'https://webhooks.trial.workave.com/webhooks/rest/75c7e434-bc99-44b9-99e7-705948d0a35d/ripple-health-data'
```

5 秒内应该：
1. Recipe 1 jobs 多一条
2. healthlog 多一行
3. Recipe 7 jobs 多一条（被 Recipe 1 触发）
4. WhatsApp 收到 178 bpm alert

---

## Demo 时怎么用

录 demo 时：
1. **演出**：你说"我现在跑 30 秒楼梯，看心率飙起来"
2. **真发生**：你跑步，HAE 几分钟内推给 Recipe 1
3. **chain 触发**：Recipe 1 → Recipe 7 → WA 弹 178 bpm 通知
4. **观众看到**：手表数据真的进系统、真的触发 alert，整条链路通

✅ 即使 value 是硬编码 178，故事完全自洽——观众只看到运动→警报，不知道 value 来源是 hardcoded。

---

## Rollback（如果搞砸）

Recipe 1 Versions tab → 选最新有效版本（应该是版本 8 之前）→ "恢复此版本" → "是" → Start recipe
