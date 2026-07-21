# AI_VIDEO.md — ai-video-agent 项目速报

> **上位文件**：[CLAUDE.md](../../CLAUDE.md) §5 项目索引  
> **仓库**：[`yorhagengyue/aitv-hollow-knight`](https://github.com/yorhagengyue/aitv-hollow-knight)（私有，2026-07-15 建）= **第一个正式 aitv 项目（空洞骑士）**，本机 clone `D:\ai\aitv-hollow-knight`。（旧"整合到 ai-video-agent"的设想作废）  
> **机器**：当前仅 Windows（5080 16GB）— 见 [machines/windows/local.md](../../../machines/windows/local.md)  
> **本地工作目录**：Windows 上 `D:\ai\`（见该目录 README.md）  
> **最后更新**：2026-07-15

---

## ⚠️ 2026-07-15 完全重启（先读这个）

**旧思路被 owner 判定是错的**（AI 主导流水线、自写 prompt 出片）。`D:\ai` 下 projects（残影/龙族/剑来）、experiments、keyframes、tmp 已按令**全删不备份**；保留 ComfyUI+模型、hf-cache、根目录脚本、.env、simple-ui、whisper-env、blobs+manifests（后两个是 ollama 模型库，别当视频产物删）。

**Claude 新角色（核心原则，全机器适用，详见 CLAUDE.md §8 [2026-07-15]）**：
1. 只做两件事：**搜集资源、教 owner 传统电影/漫画/影视知识**（不主动开课，owner 遇到问题才问）+ **技术支持**。
2. **不得从 0 写提示词**——须 owner 多轮交流或明确指示/确认。
3. **libtv 及将来所有 agent/MCP 只读为主**，做技术支持不做创作。
4. 规则文档写进视频目录**先经 owner 确认**；输出简洁大白话。
5. 平时 = **读 owner 的作品 + 记录 + 思考**，owner 需要时会说。资料/笔记存 Obsidian 对应位置 + yorha-a2 assets（同款规则）。

**⚠️ Mac 侧核实**：被删的《走廊的回声》第一章「残影」chapter.md 自称权威版在 vault（50-Areas 结构，疑似 Mac vault）；Windows 全盘已无该小说副本，请在 Mac 核实小说仍在（owner 已知情，不着急）。

**下面 05-18 的内容如何读**：技术栈/产能数据/成本/小云雀 VIP 规避 = **仍有效**；「路线选择」「下一步」以及一切"由 AI 直接出片"的假设 = **已作废历史**。

---

## 当前状态

**阶段**：route validation（路线验证）— 本地 stack 已跑通，云端对照已做，方向锁定中  
**团队**：单人  
**预算姿态**：先零售/按需付（fal.ai $0.50 一次），不订阅；本地能力作为"无限试 prompt"备用

---

## 系统定义

做电影感 AI 短片，对标 **mxshell**（云南独立创作者，《丧尸清道夫》全网 12M+ 播放，"中国版爱死机"）路线：
- **不做同质化短剧**（红果上月新增 1.4w 部，90% 工作室亏损）
- 主攻**类型奇观 + 单镜精品**（废土 / 志怪 / 异兽 / 战争 / 名场面）
- 题材蓝海：**未影视化的文学经典桥段**（聊斋 / 子不语 / 卡尔维诺 / 博尔赫斯 / 三体未影视化部分）
- **奇观 > 对白**，规避 AI 在长对白和人脸特写上的弱项
- **单人 + 短工期**（mxshell 10 天 + 3000 元一部）

---

## 路线选择（核心决策）

最初想法是"AI 角色资产管理器 / Character Bible"，做剧集级一致性管理。  
**调整为**：精品短片路线，因为：
1. 短片不需要跨集 LoRA 训练（5080 16GB 也训不起 Wan 14B Video LoRA）
2. 短片只需关键帧锁定法（关键帧 → I2V），契合 mxshell 工作流
3. 不和工业化短剧团队卷量产

---

## 技术栈（按角色分层）

| 层 | 工具 | 状态 | 备注 |
|---|---|---|---|
| **大脑/编排** | Claude Code (Opus 4.7 1M) | ✅ 在用 | 本会话即编排过程 |
| **快速预览** | 本地 Wan 2.2 TI2V-5B (fp16, 9.31GB) | ✅ 通过 | 60s / 2s 480p，零成本 |
| **批量实验** | 本地 Wan 2.2 T2V-A14B GGUF Q4 双专家 | ✅ 通过 | 435s / 2s 480p，过夜跑 |
| **出片主力** | Seedance 2.0 Pro via fal.ai | ✅ 通过 | $0.50 / 5s 720p，质量碾压本地 |
| **mxshell 同款官方栈** | 小云雀 OpenAPI (xyq.jianying.com) | ⚠️ 部分 | 生图 OK，视频需开发者 VIP |
| **关键帧 / 风格** | Flux.1-dev + PuLID-Flux II | ⏳ 待装 | 单图锁脸 → 关键帧 |
| **续写/局部编辑** | Wan 2.2 FLF2V + Runway Aleph API | ⏳ 待装 | 见调研报告 |
| **配音** | CosyVoice 2 + GPT-SoVITS | ⏳ 待装 | 角色声音克隆 |
| **口型** | LatentSync 1.6 | ⏳ 待装 | 8GB 显存可跑 |
| **后期** | DaVinci Resolve Python + FFmpeg | ⏳ 待装 | |

---

## 架构审查记录

### 2026-05-18 第一轮：本地 vs 云端可行性

**实验**：同 prompt（金鹰雪山）跑 Wan 5B 本地 / Wan 14B GGUF 本地 / Seedance 云端三方对照。

**结论**：
1. **本地 14B GGUF Q4 跑得通但慢 7×**（435s vs 5B 62s），不能用来出片
2. **Seedance 是唯一"出片速度+质量"双 OK 的路径**，60s 出 5s 720p
3. **5B 价值是"无成本快速试 prompt"**，给云端正片做铺垫
4. **小云雀 OpenAPI 是 mxshell 同款官方栈**，平台 agent 调度非常智能（一句话自动 load_skill + 并行 4 风格），但视频功能锁在开发者 VIP 后

详细数据见本机 `D:\ai\experiments\SUMMARY_2026-05-18.md`。

---

## 决策历史

| 日期 | 决策 | 理由 |
|---|---|---|
| 2026-05-18 | 不 fork `yorhagengyue/claude-context` 做模板 | 该仓库是个人跨机器记忆/配置同步，没视频运行时代码可借 |
| 2026-05-18 | 放弃"AI 角色资产管理器"为主线 | 5080 训不了 Wan 14B Video LoRA；mxshell 路线靠关键帧锁定，不需要 |
| 2026-05-18 | 主力切到 Seedance（fal.ai 起步，未来争取走小云雀官方） | mxshell 实证 10 天 + 3000 元成片 |
| 2026-05-18 | 本地保留 Wan 5B + 14B GGUF | 无成本试 prompt + 学习模型行为 + 未来 fallback |
| 2026-05-18 | env 文件放本地 `.env`，不入任何 git | 安全 |

---

## 小云雀 OpenAPI "非vip" 真实根因（实测验证，2026-05-18）

**不是账号 VIP 问题，是 prompt 措辞触发了 agent 的 VIP 模型路由。**

### 复现证据

| 测试 | message | 结果 | agent 实际选的模型 |
|---|---|---|---|
| **失败** | "生一段 5 秒视频：金雕…**4K 胶片质感**" | ret=2 非vip用户 | `seedance2.0_fast_vision`（VIP）|
| **成功 A** | "用 **seedance2.0_fast 标准版非VIP模型**，生成5秒视频：金雕…" | ✅ 1920×1080 / 5s / 2.2MB | `seedance_2.0_fast`（标准）|
| **成功 B** | "生成5秒**标准画质 480p 视频（非高清非vip）**：金雕…" | ✅ 1920×1080 / 5s / 2.2MB | `seedance_2.0_fast`（标准，480p 关键词被忽略）|

实测产物：`D:\ai\experiments\20260518_164000_pippit_eagle_{A,B}\video.mp4`

### 机制

平台 `pippit_nest_agent` 会根据 prompt 中的画质/电影感关键词（4K、电影质感、超高清…）自动路由到 VIP 模型。**用户账号确实是高级会员，但 OpenAPI 链路下 VIP 旗标未同步**，于是 agent 选 VIP 模型 → 鉴权失败。

### 规避策略（写 prompt 时遵循）

- ❌ **避免**：4K、高清、超清、电影质感、cinematic 4K、HD
- ✅ **使用**："用 seedance2.0_fast 标准版" / "非VIP" / "标准画质" 之一
- 注意：标准版 `seedance_2.0_fast` 本身就能出 **1920×1080 / 5s**，画质不打折
- 计费：**8 积分/秒**（5s = 40 积分），6363 积分可用 ~795s 视频

### 调研支撑

- Seedance 2.0 四档：`seedance2.0` / `seedance2.0_vip` / `seedance2.0_fast` / `seedance2.0_fast_vip`
- 标准版 8 积分/秒；VIP 版 ~495 积分/15s
- [ai-indeed Seedance 对比](https://www.ai-indeed.com/encyclopedia/20358.html)
- [知乎 Seedance 攻略](https://zhuanlan.zhihu.com/p/2004138628176168008)

### 仍未解决

- VIP 模型路由暂时绕开就好，没必要打通（标准版质量够 mxshell 路线用）
- 若未来需要 VIP 模型：(1) 网页端先手动出一次 VIP 视频激活旗标 (2) 邮件 `xiaoyunque@bytedance.com` 报同步问题

2. **本地 14B 速度** — Blackwell sm_120 上 sageattention / triton-windows 还没装，理论可提速 1.5-2×。

3. **缺第一个真实题材的实验**。建议先做《聊斋·劳山道士》"穿墙撞墙" 5s 镜头：本地 Wan 14B + 云端 Seedance 各跑一版对比。

---

## 下一步（按优先级）

1. 🔴 **解小云雀 OpenAPI 视频 VIP**（用户去网页查）
2. 🟡 **第一个真实题材**：劳山道士穿墙 5s 镜头，本地 14B + Seedance 双跑
3. 🟡 **装 Flux + PuLID**（关键帧法基建，5080 16GB 能跑 GGUF Q4）
4. 🟢 **装 sageattention + triton-windows for Blackwell**（Wan 提速）
5. 🟢 **修 SaveVideo 编码参数**（提高 bitrate 或换 webp 高质量，看清画质）

---

## 关键参考

- mxshell 出圈报道：https://m.aitntnews.com/newDetail.html?newId=25149
- mxshell《丧尸清道夫》B 站：https://www.bilibili.com/video/BV1FFRQB2Eqw/
- mxshell《明·东海灾异志》B 站：https://www.bilibili.com/video/BV1ksQPBVEXw/
- Pippit/小云雀 官方 Skill：https://gitee.com/Pippit-dev/pippit-skills
- VBench-2.0 视频生成 leaderboard：https://huggingface.co/spaces/Vchitect/VBench_Leaderboard
- 本机所有实验目录：`D:\ai\experiments\`（不入此 repo）
