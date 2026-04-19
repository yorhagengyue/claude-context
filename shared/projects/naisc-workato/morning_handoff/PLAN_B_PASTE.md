# Plan B — Recipe 8 echo → Kimi LLM chat upgrade

**总耗时**：≈ 10-15 min，全 copy-paste，不需要动脑  
**前置**：Recipe 8 `ripple_chat_bot` 当前是 echo baseline，要升级到 Kimi AI 对话

---

## Step 0 — 打开 Recipe 8 edit

1. 浏览器打开 Workato tab，或直接去：  
   `https://app.trial.workato.com/recipes/204159-ripple_chat_bot/edit`
2. 右上 **Stop recipe** → 弹窗确认（必须停才能改）
3. 点 **Edit**

现在 Recipe 8 有 3 个 step：
```
Trigger: Ripple-chat-reply via HTTP webhook
Step 2: Send chat reply in Twilio (Custom)  ← 现有 echo
```

---

## Step 1 — 在 Trigger 和 Twilio 中间加 Kimi HTTP step

1. 鼠标悬停 Trigger 和 Twilio 之间的 **箭头** → 出现 `+` 按钮 → 点
2. 选 **Action in app** → 搜 **HTTP** → 选 **HTTP**
3. Connection 选 **Supabase Ripple**（或任意 HTTP connection，Workato 不会用它的 auth）
4. Action 选 **Send request via HTTP**
5. 右侧面板打开后，看到 "Start guided setup" / "setup manually" → **点 "setup manually"**

## Step 2 — 填 Kimi HTTP 字段（用这 6 段 copy-paste）

### 2.1 Request name
```
Kimi chat completion
```

### 2.2 Method
下拉选 **POST**

### 2.3 Request URL（点字段 → Cmd+A → 粘 → Tab）
```
https://api.moonshot.cn/v1/chat/completions
```

### 2.4 Request content type
下拉选 **Raw JSON request body**

### 2.5 Request body（点 → Cmd+A → 粘 → 光标放最后 `"content": ""` 引号之间 → 左面板拖 `Body` pill 进去 → Tab）

```json
{
  "model": "moonshot-v1-8k",
  "temperature": 0.3,
  "response_format": {"type": "json_object"},
  "messages": [
    {"role": "system", "content": "You are Ripple, a warm and empathetic wellness companion agent. The user's smartwatch just detected an anomaly (e.g., a heart rate spike). You just sent them a WhatsApp message asking if they're okay. They have now replied.\n\nYour job:\n1. Decide whether the reply EXPLAINS the anomaly (e.g., gaming, workout, coffee, work stress, a startle, a dream).\n2. If clear and benign -> resolved=true, respond in ONE warm sentence plus a brief caring tip (<=2 sentences total).\n3. If vague or too short to judge -> resolved=false, gently probe whether they feel chest tightness, dizziness, or pain.\n4. If medical emergency signs (chest pain, dizziness, severe pain, cannot breathe, numbness) -> resolved=true, context_tag=\"medical\", strongly suggest seeking medical attention.\n5. If the reply is sarcasm, frustration, or dismissive (e.g. 'im fine stop bothering') -> resolved=true, context_tag=\"other\", one-sentence acknowledgement and step back.\n\nAlways reply in English. Be concise (<=2 short sentences). You MUST return valid JSON in this exact shape:\n{\"reply\":\"<warm english reply>\",\"resolved\":true|false,\"context_tag\":\"gaming|workout|work|stress|caffeine|startle|medical|other|null\",\"free_text\":\"<verbatim user reply>\"}"},
    {"role": "user", "content": ""}
  ]
}
```

### 2.6 Request headers（点 **+ Add header** → 填两栏 → Tab）

| name | value |
|---|---|
| `Authorization` | `Bearer sk-TEoZjBEV8fnaKWvMXk7BAzofH0qcQR24Q0hmLCUuMkApApdE` |

（Content-Type 不用加，Workato 自动加）

### 2.7 Response content type
下拉选 **JSON response body**

### 2.8 Response schema（点字段 → Cmd+A → 粘 → Tab）

```json
[
  {
    "name": "id",
    "type": "string"
  },
  {
    "name": "model",
    "type": "string"
  },
  {
    "name": "choices",
    "type": "array",
    "of": "object",
    "properties": [
      {
        "name": "index",
        "type": "integer"
      },
      {
        "name": "message",
        "type": "object",
        "properties": [
          {"name": "role", "type": "string"},
          {"name": "content", "type": "string"}
        ]
      },
      {
        "name": "finish_reason",
        "type": "string"
      }
    ]
  }
]
```

**关键**：这份 schema 让后面 Step 3 能引用 `Kimi.choices[0].message.content` datapill。

---

## Step 3 — 改 Twilio step 的 Body

1. 点 **Step 3: Send chat reply in Twilio**
2. 找 **Body** 字段，原先长这样：
   ```
   Got it, I heard: "[Body pill from Step 1]". Tagging ...
   ```
3. **清空整个 Body 字段**（Cmd+A → Delete）
4. 切到 **Formula 模式**（字段右上角切换）
5. 粘这段 formula：
```
parse_json(call('kimi_content_from_step_2')).reply
```

**如果 Formula 复杂搞不定**，fallback 用 Text 模式拖 pill：
- Text 模式下左面板 Step 2 output → `choices[0].message.content` → 拖进 Body
- 前面加一行文字 "Ripple: "（可选）

---

## Step 4 — Save + Start

1. 右上 **Save**（有错的话会报红，按提示补）
2. 右上 **Exit** → 回到 Recipe 页 → **Start recipe**
3. 状态变 Active

---

## Step 5 — 测试

打开 WhatsApp 发给 Twilio sandbox `+1 415 523 8886`：

| 发的 | 预期收到 |
|---|---|
| `gaming` | "Glad to hear it's just the excitement of gaming..." |
| `chest pain` | "I'm really concerned... seek medical help immediately." |
| `idk` | "I'm here for you. Do you feel any chest tightness..." |

3 条测试每条应该 5 秒内收到 AI 回复（不是 echo）。

---

## 故障排查

- **收到 echo 而非 AI**：Recipe 8 没 Save 或没 Start
- **收到 "Error"**：Kimi key 错 / schema 没填对 → 看 Workato Jobs → 点失败的 job 看报错
- **Twilio Body 是原始 JSON**：Body formula 没切 Formula 模式
- **Step 2 返回 401**：Authorization header 打错，检查 Bearer 前面有空格

---

## Rollback（万一录 demo 前搞砸）

**Exit without saving** → Recipe 8 恢复到 echo baseline，录 echo demo 照交不误。
