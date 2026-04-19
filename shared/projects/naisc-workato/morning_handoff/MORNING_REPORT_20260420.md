# 🌅 Morning Report — 2026-04-20

**生成**：02:17 SGT  
**状态**：死磕夜完成 95%，剩你起床 10 min 粘 + 录 demo + 发 email

---

## ✅ 你起床前已完成（不用你动）

| # | 交付物 | 位置 |
|---|---|---|
| 1 | **Plan B Kimi 粘贴手册** — 10-15 min 把 Recipe 8 echo 升级成真 AI 对话 | `morning_handoff/PLAN_B_PASTE.md` |
| 2 | **Demo 脚本 V2** — 4 min 7 分镜全链路 | `morning_handoff/DEMO_SCRIPT_V2.md` |
| 3 | **Submission email 正文** — 4/23 改几个字就发 | `morning_handoff/SUBMISSION_EMAIL.md` |
| 4 | **Kimi prompt v2** — 12 case 测试 100% 通过，prompt 锁定 | `morning_handoff/KIMI_PROMPT_V2.txt` + `KIMI_PROMPT_RESULTS.md` |
| 5 | **夜间 WA alert 循环** — 5 条 60min 间隔，03:10-07:10 SGT 每小时发一条 | `PID 33026`，日志 `~/tmp/ripple_overnight.log` |
| 6 | **HAE 链路深度诊断** — URL 对 / Recipe 1 活 / iOS 掐了；4/18 后一次没成功触发 | NAISC.md 新 overnight 章节 |
| 7 | **NAISC.md 收尾更新** | repo 已同步 |
| 8 | **CLAUDE.md §8 记忆条目** — overnight session + 2 个 correction | repo 已同步 |

---

## 📱 打开 WhatsApp 应该看到

从夜里到你醒的时间窗（假设你 7-8 点起），你会收到：

- 02:08 SGT — HR=165（我手动触发第一次测试）✅ **WA 确认收到**
- 02:19 SGT — HR=171（push 后 pipeline 健康确认）✅ **WA 确认收到**
- 03:10 SGT — HR=152 "stress spike"
- 04:10 SGT — HR=177 "mid-sleep startle"
- 05:10 SGT — HR=148 "REM dream spike"
- 06:10 SGT — HR=168 "early-morning rise"
- 07:10 SGT — HR=183 "wake-up anomaly"

**7 条测试消息**（2 条已确认 + 5 条 loop 发送中），每条都是 `Ripple live alert: heart rate spike detected N bpm. Are you OK?`

如果你早醒了来得及看全程，实时看它们一条条进来。如果一条都没收到 → Twilio sandbox 可能鉴权过期了（看 Twilio tab），或 Mac 关机了（看 `ps aux | grep ripple_overnight`）。

---

## 👉 你起床做 3 件事

### 1. 决定 echo 还是 Kimi 版录 demo（2 min 决定）

- **保守走 echo**：跳过 Plan B，直接录。Demo 里对话部分就是 echo 回声。能交但稍弱
- **激进走 Kimi**：花 10-15 min 按 `PLAN_B_PASTE.md` 粘贴 → AI 对话。视频更有看头

**推荐 Kimi**。Plan B 手册每步都 copy-paste 得到，卡不住。

### 2. 录 demo（35-50 min）

按 `DEMO_SCRIPT_V2.md` 的 7 分镜。Curl 命令都在脚本里，一键回车。

**关键道具**：
- iPhone 投到 Mac 屏幕（QuickTime Player → File → New Movie Recording → 选手机）
- Workato / Twilio / Supabase tab 提前打开
- Terminal 字号拉大

### 3. 视频上传 + email 准备（10 min）

- 视频上传 YouTube 私有链接
- 把链接填进 `SUBMISSION_EMAIL.md` 的"Demo video"那行
- 4/23 发（不是今天发，今天先把视频录完）

---

## ⏸️ 卡点（如果有）

无卡点。

如果 Plan B 粘贴手册里某步你觉得不清楚 → 直接回我，我改。

---

## ⏱ 预计 total time

| 保守走 echo | 激进走 Kimi |
|---|---|
| 录 demo 45min + 文档 10min = **55min** | 粘贴 15min + 录 45min + 文档 10min = **70min** |

上午搞定 demo，下午睡觉，4/23 发邮件就完赛。

---

## 🧠 死磕夜学到的（架构视角）

1. **Workato 有个"看不见的一层"**：所有 text 字段是 Angular-bound CodeMirror preview，程序化 JS 改值不走绑定。JS 自动化只能点 dropdown / click button，不能自动粘长文本。这是个 Trap——早踩清楚，不然重复浪费时间
2. **iOS HealthKit 的锁屏限制**是产品设计级决定，fork / 自写 iOS app 都绕不过。所有"自动同步 + 实时推送"的 Apple 生态项目都要在故事里诚实讲这个延迟
3. **Workato trial 的 webhook return 200 ≠ recipe 真处理了**：Recipe 1 对 `{"ping":"diag"}` 也返回 200，入库时给了 default source。意味着测"HAE 有没在推"不能只看 HTTP code，要看 healthlog 新行 + jobs 历史

这 3 条加进了 CLAUDE.md §8 作 correction。

---

## 🚀 我还能做什么（你回了才做）

- Recipe 1 → Recipe 7 自动触发链路设计（inline anomaly detection）
- 对话写入 Obsidian vault（git commit 路径 — 需要先 git init vault）
- RSH v1 详细设计文档（你之前说 NAISC 后不管，可以反悔）
- Demo 视频录后的 post-production 建议（剪辑节奏、字幕、注释）

你起床定个方向再说。先处理 NAISC 最后一公里。

---

**Good morning, Tommy. 去录 demo。 🎬**
