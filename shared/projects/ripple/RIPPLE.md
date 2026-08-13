# RIPPLE.md — Ripple (core + iOS + site) 项目速报

> **上位文件**：[CLAUDE.md](../../CLAUDE.md) §5 项目索引（🔴 紧急，三仓一个大项目）
> **仓库**：[yorhagengyue/ripple-core](https://github.com/yorhagengyue/ripple-core) · [yorhagengyue/ripple-ios](https://github.com/yorhagengyue/ripple-ios) · [toffemoon/ripple-site](https://github.com/toffemoon/ripple-site)（⚠️ 在 toffemoon 账号下，按 yorhagengyue 找会 404；`yorhagengyue/ripple` 是已退役旧 web，不是现役）
> **本地路径**：`~/Desktop/ripple-core` · `~/Desktop/ripple-ios`（⚠️ `~/Desktop/ripple-site` 在本机**未 clone**，2026-08-09 核实）
> **最后更新**：2026-08-09（补设计师交接线：08-06 面谈 → 交接包 + 71 张基线截图 + Figma 基线板；一个 owner-only 决定悬着）

---

## 当前状态

**阶段**：已上架运营期。**✅ v1.1.0 (7) 2026-08-04 过审发布**（0730 评审会 P0-P5 全量；08-02 深夜提交，一拒零复发；iTunes Lookup 实证 currentVersionReleaseDate 2026-08-04T05:55:41Z）；v1.0 (4) 2026-07-14 首发（商店名 "Ripple Health AI"，免费，iOS 18.0+，Apple ID 6786394791）。**zh build 1.1.0 (8) 已建成全绿、未提审**——随五分熟版本下次提审（ASC zh 元数据未做）。官网 **ripple-health-ai.com 已上线**（2026-08-05 实证 200；备地址 ripple-site-puce.vercel.app）。
**团队**：owner（Gengyue）+ Claude（2026-08-01 起授权做 ripple-ios 产品/UI 方向决策，见决策历史）。

**留存现状（2026-08-06 owner 校准：不是问题，旧「头号问题」framing 作废）**：2026-07-28 生产库实查 31 注册含 9 测试号、真人约 15（Apple 7 人全登录成功）；过去 7 天 0 人登录；07-18 后零新增；有真 Apple Watch 数据的仅 2-3 人。**这些数字在预期内**——当前处推广阶段，大量推广动作走线下，节奏刻意放慢，不着急。后续 AI 读到旧记录（含 LOOP-PROGRESS.md 同期内容里的「头号问题/死循环」措辞）不要当成当前危机，以本条与 §8 [2026-08-06] correction 为准。

**当前重心 = 设计交接（2026-08-06 起）**：owner 08-06 与设计师面谈 37 分钟，授权范围 = **Home / Calendar / Notice 三屏及其下所有内容（含日详情、长按解释卡、调查页）的全部 UI 重设计 + 动效**；Me/设置与官网明确不画；承诺"功能只增不删"。08-07/08 ripple-ios 交付两件：`docs/HANDOFF-DESIGNER.md`（会上范围/8 条红线/owner 自认的问题/开放题；**§9 是给 owner 的，发出前须删**）+ `docs/asc-screenshots/current-v1.1.0/` **71 张现状基线截图**（8 类、零重复哈希、demo 账号强制英文，清单真源 `docs/BASELINE-SHOT-LIST.md`）已上传 Figma 基线板（文件在 owner 个人 drafts，**权限/邀请须 owner 自己设**）。⚠️ **这 10 个 commit 在分支 `gengyue/figma-baseline` 上尚未 push**（2026-08-09 核实），只存在本机 iCloud 桌面。

**⚠️ owner 愿景稿 `Vault/01 - Projects/Ripple/Ripple 8.8.md`（2026-08-08，owner 亲写，未决、明说"长期计划、中途可能改"）**：把 Ripple 定为**双主题（日常 plan / 健康）+ 圆环为主 UI**——一圈 = 24h 时间轴，事件成弧、健康成整圆渐变，点事件进子圆、可无限递归；Notice 升级为**伪 Claude Code**（首次点按自动触发调查、可看"它在查什么"、长按中间推理引用并 prompt 纠正、多轮带上下文、即用即弃、满意后沉淀为组件化静态报告）+ 记忆系统（Me 页可见可编辑，owner 原话"最好有一部分记忆是用户看不到的"）。**owner 2026-08-09 对三处疑似冲突的裁决（以下为准，别再当冲突处理）**：
- **(a) 对话型 Notice —— 以当前为准，红线不改，暂不告诉设计师。** 8.8 的多轮对话是长期形态，当前版本仍是「AI 入口只有长按、无聊天框」。⏸ 未决的代价：Notice 是 8.8 里结构变动最大的一屏却在设计师范围内，Claude 建议（owner 未表态）= 告知设计师「Notice 只做视觉语言、不押结构」，并把红线措辞从永久禁令「不要加聊天框」改为陈述现状「当前版本没有聊天框」（理由同 §8 [2026-08-02] 呈现家族 #7：描述现状的文档写成禁令，改主意后就在教人做错事）。
- **(b) 隐藏记忆 —— Claude 的反对基本收回。** owner 澄清：要藏的是 **AI 自己的思考过程/规则**，连 API 都不出、放后端 repo 代码里，大厂通行做法，不是藏用户数据。**留下的判据**：同一份内容对所有用户一样 = 代码，可藏；因人而异 = 关于该用户的数据，存后端也仍是其个人数据，该可见可删（对应 8.8 原文「记下用户的特性」那半句）。大厂划的是同一条线：system prompt 藏、ChatGPT memory 可见可删。
- **(c) Home 不是冲突。** owner：Home 的功能本来就是状态页，现在也是几个 chart 说明今天状态。2026-08-09 截图核实属实（`1-home/01-home.png`：状态词 + 一句话 + HRV 异常卡 + LAST 7 DAYS 四张带迷你图的卡 + PLANS）。**真正的开放题（Claude 提出，未决）**：那四张卡是「过去 7 天」，8.8 的环是「今天 24h」，**时间尺度不同**——环进 Home 要定的是「替掉哪一块」；替掉七天卡就丢了"跟自己常态比"这个区别于 Apple Health 的视图，都留则 Home 过长。

**⏸ 发交接包前必须改**：`HANDOFF-DESIGNER.md` §2 对 Home 的文字描述与截图不符（文档写"信号：HRV/静息心率/睡眠/呼吸率/血氧，每条给数值+常规范围"像九行列表；实际是 LAST 7 DAYS 四张卡片带迷你折线）。设计师会同时拿到文字与 71 张截图，对不上会先怀疑自己。§2 需按新截图整节重写。

Claude 2026-08-09 对 8.8 的其余评估（圆环当主导航的几何/触控硬约束、日常半边"手工标注 + 有竞品"该做薄、Notice 伪 claude code 该排第一及其成本/合规代价、53 条规则库可当其 tool call 顺带满足 1.4.1）见对话，owner 未表态，未落盘成文档。

**悬着的 owner-only 决定（挡住 Mac 侧后续施工）**：五分熟的圆环方向稿 `ripple-ios/docs/DESIGN-DIRECTIONS-RING-INVESTIGATION.md`（圆环三落点 + investigation 大改 A/B/C 三稿，Claude 推荐 C「盘为索引，卷为内容」；公理 = 一圆 = 24h 时间盘不是进度环）与设计师的全屏重画授权**目标重叠**。三种走法：甲=先定方向稿、把圆环语义作为既定前提写进交接包；乙=方向稿暂停等大板；丙=各画各的。**当前默认状态是丙**（设计师不知道有方向稿），大概率一边白做。另：报价与测试账号会上未落定（交接包 §9③）。

**圆环第一件落地（2026-08-09，owner 指示「单开一个页面做圆环，别直接写在 app 里面；冷启动暂用现有 UI，后续再定」）**：`ripple-ios/RippleApp/RingLab/`（`RingGeometry.swift` 纯逻辑进 logic-test target + `RingLabData.swift` 假数据 + `RingLabView.swift` 台子），入口只有 dev-only 的 `RIPPLE_SCREEN=ringLab`，不在任何 tab、无人链接、整目录可删。15 条单测全绿、真机模拟器截图+点击命中实测通过（tap→Lecture 08:30–10:30 · 79pt along × 22pt across）。**未提交**（截至该日仍在工作区）。
**实测出的硬约束（不是估算，台子上有读数、测试里有断言）**：iPhone 17（402pt 宽）上圆环最大半径 **124pt**（再大超屏，台子自动夹紧并写明）；此时 **1 小时 = 32pt 弧长，短于 1h21m 的事件无法直接点击**；普通上学日 **35 段里 29 段低于 44pt**（通勤/午饭/晚饭/健身/课间全部落空，只有 2h 的课与整段睡眠可点）；24 个小时级健康桶**无一可点**（小时已是最粗粒度）。半径 168pt 才能让 1 小时到 44pt = 336pt 直径，装不下。两个轴不对称：**径向可用隐形触控区补救，切向不能**（邻居就在旁边），snap-to-nearest 能救稀疏的一天、救不了密集的一天（已写成对照测试）。
**结论边界**：以上只证明**圆环不能同时充当"看"与"点"两层**，不证明圆环方向错。出路（未决，owner 说先别管设计）= 拖拽放大时间窗让弧变长，或圆环当地图、点击落在旁边列表。

**同日转向（owner：「这个圆环完全不是很够，去抄苹果手表运动合环那个动画和 UI，尽量用官方现有素材」）** → 台子第二页 `RIPPLE_SCREEN=activityRings`（`ActivityRingLabView.swift`）：
- **关键事实：苹果的活动圆环是公开 API，不需要抄**——`HKActivityRingView`（HealthKitUI，iOS 9.3+，SDK 头文件实证），喂 `HKActivitySummary`（三个值全可写，能灌自定义数字），`setActivitySummary(_:animated:)` 才有动画、直接赋值没有。已包成 UIViewRepresentable 跑通截图。
- **它锁死三件事**：永远三环且语义固定 Move/Exercise/Stand；颜色是苹果红/绿/蓝**不可改**；它是**进度环**。三条分别撞上 Ripple 现有的三条自定规矩（交接包 §3 的"不要红绿表好坏"、方向稿的"圆环=24h 时间盘不是进度环"、以及健康指标本无"达标"概念）。
- 已另建可换色的 SwiftUI 重建版并排对照（含 track/圆头/角向渐变/收尾圆头压过起点带阴影）。**实现要点**：那个压过起点的收尾圆头不只是装饰，它同时盖住角向渐变首尾相接的接缝；圆头必须放进整环大小的容器里再旋转（直接给圆点加 rotationEffect 是绕它自己转），且静止位在 3 点方向（整环已带 -90°）。
- **owner 当场纠正（同日）**：「我只是套用这个环而已，我不希望逻辑是遵照它的——只按我们的设计抄它的 UI 和动画，不要把它的逻辑也抄过来。」Claude 上一轮"要先决定 Ripple 里什么东西算完成"的追问**本身就是把苹果的逻辑搬了过来**，作废。`HKActivityRingView` 因此只作参照、不作方向（它强制 Move/Exercise/Stand + 红绿）。
- **落地 = 第三页 `RIPPLE_SCREEN=dayRing`（`DayRingView.swift`）**：苹果的做工 + Ripple 的语义。**环填满的原因是时间走完，不是达成**——每天午夜必合、人人都合、无人可能"没合上"，因此拿到合环观感却零及格/不及格暗示；收尾圆头 = 现在几点。颜色仍是 teal 常态内 / amber 常态外 / 暗 无读数，用**角向渐变的硬断点**实现（同位置两个 stop），所以是一整条环但每小时语义保留——这也是必须的：24 个相邻小段上做不了圆头收尾（圆头会互相压）。计划在外圈单独一层，**未发生的淡显**（苹果无此区分）。
- **多环比例（owner：「圆心太大太大，周围放不了几条」→ 继续复刻）**：照苹果组件实测的比例重做——**洞 = 直径 42%、环间隙 3pt、环厚由环数反推**（加环只让环变薄，洞不动）。300pt 外径下 5 条环 = 环厚 15pt，仍清晰。初版一条 26pt 环配 260pt 圆 = 80% 空洞，正是 owner 指出的问题。
- **owner 已拍板（2026-08-09）：颜色 = 身份，状态点进去看即可。** 落地：每条信号一个色（环面上不再有 teal/amber），**有读数的小时上色、无读数留空让底槽透出**——这一步是必须的，否则时间以同一速度填满所有环，五条环会是五条相同的弧；状态改由**点击揭示**（实测：点 HRV 环 03:00 → "HRV · 03:00 · outside your usual range"）。图例（由外到内）因此成为设计的一部分而非调试件。
- **⚠️ 这个决定的代价，台子已量出并印在屏上**：4 条环时每条 **19pt**，对 44pt 最小触控。**与此前"径向可用隐形触控区补救"的结论不冲突但被限定**——那条只在**单环**成立；多环相邻时撑大一条就抢走邻居的，补不了。故"点进去看状态"在 4–5 环时不可靠。出路（Claude 提出，owner 未选）：①环数压到 2–3（25–38pt）②**点击不区分环 = 点一个时刻给出那一刻的全部信号**（Claude 倾向，且与"调查中心"调性一致、顺带绕开 44pt）③点后弹小选择器。警告文案随环数动态变化。
- **配色（2026-08-09，用可视化调色板校验器算的，非手挑）**：暗色底 #0A0C0F、相邻对，五项全过的四色 = teal `#18A18F` / blue `#3987E5` / magenta `#D55181` / violet `#9085E9`（最差相邻：品红↔蓝 CVD ΔE 15.9、蓝↔青 正常视力 17.0）。两条可复用结论：①**品牌 accent 不能直接当图表色**——`#37C2BA` 亮度 0.74 超出暗色区间 0.48–0.67，须降到 `#18A18F`；②前一版"青 + 浅青"是硬错（正常视力 ΔE 6.1 / 标准 15 = 两条同色环）。**四色是上限**：琥珀/珊瑚被状态占用、绿色自带"好"的暗示 ⇒ 只剩青→蓝→品红→紫一段弧，第五色必与其一在红绿色盲下塌陷。**与触控上限独立同向**（4 环=19pt<44pt），两条无关约束都指向"更少的环"。计划环故意压到 chroma 下限之下（`3C4A57/4E6E8E/5A6B7A/6E6076/4A6B63`）以退居背景。
- **真界面集成（`RIPPLE_SCREEN=dayRingHome`，`DayRingHomePreview.swift`）**：环 + **真的 `DayBody`**（与线上 Home / 日详情同一组件，`statusPageLimit: 2`，种子用真实 `/v1/day` 抓包 JSON）。`TodayView` 未动。**只有集成后才暴露的两件事**：①**环把 Home 的答案挤下去**——与 owner 07-31「Home = 状态页，一句状态词就是这一页」（还为此砍过一块）冲突；环答"何时"，状态词答"怎么样"，环在上等于主次颠倒。Claude 倾向答案在上、环在下或做小，但 `DayBody` 只开放 header 插槽，改需动线上文件，**未动、待 owner 令**。②**同一 HRV 一屏两色**：环上青（身份）、证据卡琥珀（状态）——各自正确但并排读成矛盾（同 §8 呈现家族 #1）。解法：环旁给名字对照 + **环永不使用琥珀/珊瑚**，保住状态色在整屏的唯一含义。③该预览未拉周数据 ⇒「环是否替掉 LAST 7 DAYS 四卡」仍无法回答。
- **实现坑（三个都只在截图里现形）**：①两层环的间距要按描边**边缘**算不是中心线，按中心线算会重叠 4pt 糊成一条；②`Circle().stroke` 的中心线在图形边缘（半径 D/2、且溢出 frame），而圆头按 (D−w)/2 摆 → 差半个环宽、圆头掉进环内侧，修法是给描边加 `.padding(lineWidth/2)`（`.strokeBorder` 对 trim 过的 shape 不可用）；③小时区间左闭右开 ⇒ 24:00 不属于任何一小时、取色回落"无数据"变灰，而那正是合环的那一帧。
- 另：app 当前**未申请** `activitySummaryType()` 读权限，真实活动环数据拿不到，要加等于改线上同意屏。

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

- `ripple-core/docs/`（**2026-08-09 大整理**：root 20 份收到 6 份）：`DATA.md`（**数据盘点真源**——9 指标生产实查 + 真机探测四分类 + 建模前提；Obsidian 有快照）、`CONTRACT.md`（端点形状真源）、`ARCHITECTURE.md` 与 `API.md`（同日修掉已知漂移：softAuth 默认 401、cost-guard 三种拒绝、settings 浅合并、三个 recompute 函数、agent 工具表）、`PROJECT.md`（重写过时开头）、`LOOP-PROGRESS.md`（逐轮历史，留在原地）、`research/`、`compliance/`（三件 DRAFT）；**其余全进 `docs/archive/`**（PLAN/BACKLOG/ROADMAP/七份完结 PLAN-*/两份一次性报告/R 轮工件/plan/ 三轨，archive/README.md 有清单）。`.cursor/skills/ripple/SKILL.md` 同日修正单一 7% 阈值错误（实为 25%/7%）与过时文档表。
- `ripple-core/scripts/`：`setup_demo_account.py`（demo 账号）、`refresh_fixture_jwt.py`（JWT 续期工具）等 13 个
- `ripple-core/.cursor/skills/ripple/SKILL.md`：项目宪法级 guardrails（唯一 agent 指引文件；ios/site 仓无）
- `ripple-ios/docs/` **设计交接线（08-06~08 新增）**：`HANDOFF-DESIGNER.md`（交接包，§9 owner-only）、`DESIGN-DIRECTIONS-RING-INVESTIGATION.md`（圆环 A/B/C 方向稿，待选）、`PLAN-FIGMA-BASELINE.md` + `BASELINE-SHOT-LIST.md`（基线拍摄计划与清单真源）、`PROMPT-MAC-FIGMA-BASELINE.md`、`asc-screenshots/current-v1.1.0/`（71 张 + README 含复现命令与忠实度边界）、`PLAN-CALENDAR-EVENTKIT.md`、`ASC-ZH-METADATA-DRAFT.md`
- `ripple-ios/docs/`：`APP-STORE-SUBMISSION.md`（上架清单+三次拒审应对+ASC 记录）、`PLAN-HOME-STATUS.md`（Home=状态页 owner 决策档）、`UI-POLISH-TODO.md`（交人类设计师的打磨清单）、`PLAN-L10N.md`（中文版 Z1-Z7+品牌词 veto）、`V1-IMPLEMENTATION-PLAN.md`、`brand/`（logo/appicon SVG）、`legal/`、`asc-screenshots/`

## 决策历史

- **2026-08-09 — HAE 旧门删除（已上线实证 404）+ 真机 HealthKit 探测完成**：`/v1/ingest/hae` 全删（路由/解析器/单位表/别名表，含墓碑测试防复活），native 成唯一写入方；ripple-core `f2fd667`，线上 404/health/native 三项实证，全量 237 测试绿。⚠️ owner 手机的 Health Auto Export 自动推送待 owner 手动关。真机探测（`RIPPLE_SCREEN=healthProbe` 台子，结果自动落 Documents 由 devicectl 拉取）：**手机源信号密（步行力学 4 项各 1300-2400 条/90d、耳机音量 3230 条、睡眠分期全套 243 条）、表源信号稀（RHR 2 条/7d、HRV 10 条/7d）**；死信号 = 腕温（SE 无传感器）、血氧（5-22 后断，SE 无传感器——9 正式指标之一对无传感器用户是死格子，产品问题）、锻炼记录 0（行为）。建模含义：戴表检测 + 手机源连续性并行；睡眠分期是最便宜的增强。
- **2026-08-09 — 算法层要完整重构，起点 = 佩戴时段检测（owner 定，方案讨论中）**：owner 原话「我觉得完整是要重构的」「最初最初至少应该检测用户带手表的时间段」。触发 = Claude 一轮深读（13 agent）发现现有算法层只有一个统计想法（7d 均值 vs 含它的 30d 均值，阈值 25%/7%），且对间歇佩戴者结构性失效——0028 已诊断（owner 账号 n_30d == n_7d == 19 → deviation 恒为 0）、`v_wear_day`/`worn_days()` 已建但**至今无任何代码读它**。方向：分层（可信度 → 个人化标准分 → episode 状态机 → 归因前置 → 呈现）+ 历史回测既做阈值校准也做 onboarding 首屏；不上 ML。**第 1-2 步已立项：`ripple-core/docs/PLAN-ENTITIES.md`（wear_segment + night 两实体，纯派生可重放）+ `PLAN-EVIDENCE-BUNDLE.md`（③⑤ 契约）+ `RESEARCH-BASELINE-AI.md`（62 条已验证引用）**。owner 2026-08-09 三项拍板：①wear_segment **输出三态** worn/not_worn/**unknown**（缺样本有"没戴"与"没同步"两种相反成因，靠"证人信号"=同时段有无其它手表样本区分）；②验证要**弱真值 + 分开报漏判/冤判**（睡眠分期=硬正样本），冤判代价更大故检测器须偏向少判没戴；③**分工 = 化验科(代码)/医生(模型)**，模型不可替代能力里 owner 定 **「链接」第一**（把用户自己写的"赶due到三点"跟当晚 HRV 连起来，规则库永远编码不了，也是区别于 Apple Health 之处）——**⏸ 链接单开一个 session 详细规划**。配套更正：此前"AI 一个数都不许自己算、只能复述"说过头了，PHIA 的 84% 本身就是 agent 驱动+工具的成绩、22% 才是心算，正确的线是**不许产出非代码算出的数字，但可以决定查什么/问什么/什么值得说**；且 SKDH/GGIR 吃原始三轴加速度、HealthKit 不给，**不可 vendor 只作方法参照**。发火率建议 **0.5–1 段/人月**（三个真实部署 0.24–1.9 + Alavi 73% 用户接受度，仍待 owner 定）；**③+⑤ 合流调研已交付：`docs/research/flow-detect-explain.md`（owner 提出"⑤ 的 AI 和 ③ 合起来写"，调研结论 = 合并正确，含义 = 检测层产出类型化 Assessment{score/coverage/contributors/episode}，⑤ 退化为叙述者+缓存；一手背书 NightSignal 夜+状态机(Nat Med'22, 代码公开)/Mishra CuSum(NBE'20, R 包)/Plews SWC=0.5×CV 阈值推导/PH-LLM+PHIA(Nat Med & Nat Comms'25, LLM 只该消费聚合特征)）**；同日清障：HAE 门删除、`v_daily_agg` 双机制删除（0033，含 sum_val 列）、文档大整理 + `DATA.md`。**night 骨架已定稿（owner 2026-08-11）**：三层来源 `observed`（分期 session，全质量）/ **`phone_rest`**（owner 提出、真机验证：iPhone 运动样本的夜间静默段=手机休息窗口，~14/14 夜覆盖 vs 手表 90 天仅 8 夜；入睡端准到 15–60 分钟、醒来端系统性偏晚 2–5.5h、与佩戴段交集可修——**只给窗口不声称时长**）/ **问用户**（确认通道，约束=不能过于平凡，随冷启动设计）。**已排除并有实测依据**：`inferred` 取消（零 session 学不出习惯）、`inBed` 作废（90 天实测 0 个可救夜，且设备本身大多数夜不记录——owner 佩戴 9.4h 整夜连 inBed 都没有）、Screen Time 平台锁死（沙箱渲染 only，绕法需 Family Controls 特权 entitlement）。实现硬约束：phone_rest 只能在手机上算（后端步数是日总量无盘内时间戳），iOS 算好上传，另案。验证为 n=1，上线前须真用户复测。⏸ 待 owner 定：发火率设计目标（**基线改吃夜之前必须定**）、「不够了解你」是否在 UI 显形。
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

0. **owner-only：圆环方向稿 vs 设计师授权的重叠，选甲/乙/丙**（见上方「悬着的决定」）+ 交接包发出前删 §9 + Figma 权限 + 测试账号/报价。**这条不定，Mac 侧施工无法排期。**
0b. **push `gengyue/figma-baseline`**（10 commit 未推，含 71 张基线截图，只在本机 iCloud 桌面）
1. **GTM 侧承诺的 onboarding flow + UX rework**（§5.0 待办主线；推广期正常待办、不是救火——留存校准见上方）。**⊕ onboarding 必须确认「有无手表 + 款式」并按传感器能力适配 UI（owner 2026-08-09 定，先不做）**：源自真机探测——SE 无腕温/血氧传感器，血氧作为 9 正式指标之一对这类用户是永远不更新的死格子。实现提示：**优先自动检测而不是问**——HealthKit 样本的 `sourceRevision.productType` 就带型号（如 `Watch5,12`），回填一到就能推出能力表（有无温度/血氧传感器）；只有零数据的全新用户才需要问。UI 侧 = 无传感器的指标不展示/明示「你的设备不支持」，而不是留死格子。
2. OpenAI 用量上限（owner 自有门规，agent 不动）
3. `ripple-ios/docs/UI-POLISH-TODO.md` 视觉精修（交人）
4. SMTP 用个人 Gmail（gengyue081）发陌生人验证码，deliverability 隐患未处理
5. Vercel 防火墙：已决定暂不做（hobby 档，cost-guard 应用层限流已够）

## 下一步

卡在上方待办 0（owner-only 决定）。之后：设计师大板 → 过红线 → Mac 侧静态原型截图过眼 → 施工；GTM 侧 onboarding flow + UX rework 与设计线同一条路上。技术 gate 文化不变：iOS 单测+UITests、core npm test、部署+远程冒烟、逐轮截图实看，全绿才 claim。
