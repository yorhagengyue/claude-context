# RIPPLE.md — Ripple (core + iOS + site) 项目速报

> **上位文件**：[CLAUDE.md](../../CLAUDE.md) §5 项目索引（🔴 紧急，三仓一个大项目）
> **仓库**：[yorhagengyue/ripple-core](https://github.com/yorhagengyue/ripple-core) · [yorhagengyue/ripple-ios](https://github.com/yorhagengyue/ripple-ios) · [toffemoon/ripple-site](https://github.com/toffemoon/ripple-site)（⚠️ 在 toffemoon 账号下，按 yorhagengyue 找会 404；`yorhagengyue/ripple` 是已退役旧 web，不是现役）
> **本地路径**：`~/Desktop/ripple-core` · `~/Desktop/ripple-ios` · `~/Desktop/ripple-site`
> **最后更新**：2026-08-05（随 §8 同族合并建文件）

---

## 当前状态

**阶段**：已上架运营期。**✅ 2026-07-14 过审自动发布**（第三次提交成功；商店名 "Ripple Health AI"，免费，iOS 18.0+，Apple ID 6786394791）。官网 **ripple-health-ai.com 已上线**（2026-08-05 实证 200；备地址 ripple-site-puce.vercel.app）。
**团队**：owner（Gengyue）+ Claude（2026-08-01 起授权做 ripple-ios 产品/UI 方向决策，见决策历史）。

**留存现状（2026-08-06 owner 校准：不是问题，旧「头号问题」framing 作废）**：2026-07-28 生产库实查 31 注册含 9 测试号、真人约 15（Apple 7 人全登录成功）；过去 7 天 0 人登录；07-18 后零新增；有真 Apple Watch 数据的仅 2-3 人。**这些数字在预期内**——当前处推广阶段，大量推广动作走线下，节奏刻意放慢，不着急。后续 AI 读到旧记录（含 LOOP-PROGRESS.md 同期内容里的「头号问题/死循环」措辞）不要当成当前危机，以本条与 §8 [2026-08-06] correction 为准。

## 系统定义

个人健康基线调查 app：Apple Watch/HealthKit 数据 → 后端算个人基线与异常 → iOS「调查中心」呈现（shows-its-work，无 chatbot）。三仓一体：core=后端与契约，ios=App，site=宣传官网。**Ripple 是一个项目不是三个**——"先做 iOS 还是先做官网"不成立，内部先后按依赖与 GTM 需要排。

## 技术栈

| 层 | 选型 | 备注 |
|---|---|---|
| 后端 | Node/TS + Hono + Supabase（RLS）| 部署 Vercel（ripple-core.vercel.app），契约冻结见 `docs/CONTRACT.md` |
| LLM | **OpenAI `gpt-5.4-mini` 独家**（数据不进中国；azure/kimi/deepseek 全从 registry 删）| 坑：GPT-5.x 要 `max_completion_tokens` 不认 `max_tokens` |
| iOS | SwiftUI + HealthKit + SIWA | Bundle `com.ripplehealth.ios`，付费 team `6745G7RTY5` |
| 推送 | APNs 双 .p8 已通电（2026-07-29，私钥 `~/Documents/RippleKeys/`）| 测试推送与真晨报均实证 |
| DB | Supabase **Pro 已升**（2026-07-28，每日备份实证；PITR 不买）| 升级前实证零备份是当时最硬风险 |
| 法务页 | ripple-legal.vercel.app 托管（privacy/terms/support）| 源码 `~/Desktop/ripple-legal/`（未入 git，改完 `vercel deploy --prod`） |
| 官网 | Vite，Cloudflare + Vercel 双地址 | repo 文档只有 2026-08-02 一轮 `docs/superpowers/` 规划 |

## 仓库文档地图（详细记录都在仓里，别在记忆里重复）

**逐轮案例全录 = `ripple-core/docs/LOOP-PROGRESS.md`（约 2000 行，记到 L10N Z7 / 2026-08-04）**——后端 10 轮 → R0-R22 → S1-S23 上架 → A/B/C-loop → D/E-loop → build5 → H/K/W/S-round → Z1-Z7 全程在册。§8 验证/呈现/数据各家族的原始案例几乎都能在这里找到（例外两条见下「经验教训」）。

- `ripple-core/docs/`：`CONTRACT.md`（v1 端点 JSON 冻结真源）、`ARCHITECTURE.md`、`API.md`（部分过时，以 CONTRACT 为准）、`MORNING-REPORT.md`、`NIGHT-AUDIT-2026-08-02.md`、`PLAN-*.md`（各 loop 立项书）、`research/industry-app-baseline.md`、`compliance/`（三件 DRAFT）
- `ripple-core/scripts/`：`setup_demo_account.py`（demo 账号）、`refresh_fixture_jwt.py`（JWT 续期工具）等 13 个
- `ripple-core/.cursor/skills/ripple/SKILL.md`：项目宪法级 guardrails（唯一 agent 指引文件；ios/site 仓无）
- `ripple-ios/docs/`：`APP-STORE-SUBMISSION.md`（上架清单+三次拒审应对+ASC 记录）、`PLAN-HOME-STATUS.md`（Home=状态页 owner 决策档）、`UI-POLISH-TODO.md`（交人类设计师的打磨清单）、`PLAN-L10N.md`（中文版 Z1-Z7+品牌词 veto）、`V1-IMPLEMENTATION-PLAN.md`、`brand/`（logo/appicon SVG）、`legal/`、`asc-screenshots/`

## 决策历史

- **2026-08-04/05 — ripple-site 转正官方宣传站**：ripple-health-ai.com + ripple-site-puce.vercel.app 即官方站；08-05 部署完成本机实证 200（vercel.app 备用地址从中国直连超时 = 已知网络问题非部署问题）。
- **2026-08-01 — owner 授权 Claude 做 ripple-ios 产品/UI 方向决策**（原话"你现在更多可以扮演这个项目的决策者"）：[2026-07-01]「美学微调交人做」的边界**仅在 Ripple 解除**，其它项目照旧。没变的：决策必须给理由、owner 随时能否决、像素级 craft 实现后须截图实看才许说完成、只说"实现了决策"不自称"好看"。配套行为规则见 §8 [2026-08-01]「退让也要有理由」。
- **2026-07-02 — LLM 切 OpenAI 独家**：DeepSeek（数据驻留问题）→ Azure（过渡）→ OpenAI 官方。凭据六项已全轮换（坑：Supabase legacy JWT 键要 `PUT /api-keys/legacy?enabled=false` 单独停用）。归档上传坑：带 HealthKit entitlement 必须读+写两条 purpose string 都有（`NSHealthUpdateUsageDescription`），与是否真写无关。
- **2026-07-02 — demo 账号固定 OTP 常驻 prod（双用途：上架审核 + 团队日常测试）**：demo=`ripplehealth@test.com`、码=`526811`；GoTrue BEFORE UPDATE 触发器重钉 fixed-hash + pg_cron 每小时保鲜，demo 登录零邮件发送；iOS `SupabaseManager.sendOTP` 对 demo 邮箱 no-op。机制与踩坑（sha224/recovery_token/别用 extensions.digest/全小写邮箱）见 §8 [2026-07-02] OTP 条。⚠️ 安全权衡（owner 已确认）：email+固定码是公开可知凭据，**此账号只能灌 fake 种子数据、绝不接真实健康数据**；要拆后门 `drop trigger ripple_demo_fixed_otp_trg on auth.users` + `drop function public.ripple_demo_fixed_otp()`。
- **2026-07-01 — v1 前端替换终局**：旧仪表盘彻底重做「调查中心」（日历 Home + 长按 Explain Sheet 唯一 AI 入口 + 调查引擎三态 + anomaly 通知箱；legacy 全删）。核心指令 = 分析读数要联动 events + lifestyle facts；敏感 facts（病症/用药）内容门绝不 surface。原生 Apple 登录同天接线 live。

## 经验教训的落点（重要，别找错地方）

- **跨项目通用教训**已蒸馏进 CLAUDE.md §8 五大家族条：[2026-08-04] 验证家族 · [2026-08-04] SwiftUI/XCUITest 坑清单 · [2026-08-02] 数据摄取与聚合 · [2026-08-02] 呈现/文案/一致性 · [2026-08-01] 系统设计/合规/协作 + [2026-07-30] 自驱 loop 纪律。**逐轮原始案例在 LOOP-PROGRESS.md**。
- LOOP-PROGRESS.md **没记下泛化教训**的两条（只在 §8 家族条里）：rate limit 要装在缓存之后（系统设计家族 #1）、锚点不是时间下限（数据摄取家族 #3）。
- **iOS/App Store 专项**留在 §8：[2026-07-09] 健康 app 拒因 pattern（四拒因+二拒+全手册审计 10 条）· [2026-06-27] HealthKit entitlement 坑 · [2026-07-30] 装 app 到新真机 · [2026-07-02] iCloud 目录 codesign · OTP demo 机制条。
- 工作边界：[2026-07-01]「UI 美学微调交人做」全项目通用，Ripple 例外即上方 08-01 授权。

## 当前阻塞点 / 待办

1. **GTM 侧承诺的 onboarding flow + UX rework**（§5.0 待办主线；推广期正常待办、不是救火——留存校准见上方）
2. OpenAI 用量上限（owner 自有门规，agent 不动）
3. `ripple-ios/docs/UI-POLISH-TODO.md` 视觉精修（交人）
4. SMTP 用个人 Gmail（gengyue081）发陌生人验证码，deliverability 隐患未处理
5. Vercel 防火墙：已决定暂不做（hobby 档，cost-guard 应用层限流已够）

## 下一步

按 §5.0：onboarding flow + UX rework（GTM 侧）。技术 gate 文化不变：iOS 单测+UITests、core npm test、部署+远程冒烟、逐轮截图实看，全绿才 claim。
