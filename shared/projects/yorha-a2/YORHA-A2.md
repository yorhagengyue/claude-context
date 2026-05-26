---
project: YoRHa-A2
status: framework v0 (short-video) + concept (conversion-site)
last-updated: 2026-05-25
upstream: ../../CLAUDE.md §5
manifesto: SETUP.md
parts:
  - short-video/SHORT-VIDEO.md
  - conversion-site/CONVERSION-SITE.md
---

# YoRHa-A2 — 顶级状态板（hub）

> **本文件是顶级 hub**。
> 主旨 / 主导思想 / 战略 / Claude 姿势 / 操作规约 → [SETUP.md](SETUP.md)
> 短视频 part 状态板 → [short-video/SHORT-VIDEO.md](short-video/SHORT-VIDEO.md)
> 转化站 part 状态板 → [conversion-site/CONVERSION-SITE.md](conversion-site/CONVERSION-SITE.md)

---

## TL;DR

**一句话**：用 AI 运作机制解释人性现象的内容 + 服务项目。**分两 part**：

```
YoRHa-A2
├── short-video    ← 引流（用 AI×人性 内容拉流量 / 国内流量为主 / 国外为 conversion-site 导流）
└── conversion-site ← 转化（独立网站 + AI 咨询 / 国外付费为主 / 国内 backup）
```

**护城河**：这个 AI↔人性 映射只有 user 能持续输出（LLM 思考模式 ≈ 人类思考模式 + user 两边都熟）。已被 subagent / 分手 抖音文案验证。

**当前阶段**：short-video framework v0 定 / conversion-site 还 concept。两 part **并行启动**。

完整 framing / why-now / 主导思想 / 战略地图 / Claude 姿势 → [SETUP.md](SETUP.md)。

## 两 part 状态总览

| Part | 角色 | 当前状态 | 详细状态板 |
|---|---|---|---|
| **short-video** | 引流 | framework v0 定稿，待 user 跑第一波 10 条文案 | [short-video/SHORT-VIDEO.md](short-video/SHORT-VIDEO.md) |
| **conversion-site** | 转化 | concept 阶段，8 个核心问题待 user 专题想清楚 | [conversion-site/CONVERSION-SITE.md](conversion-site/CONVERSION-SITE.md) |

两 part **并行启动**（user 决定）。

## 两 part 关系图

```
短视频 (short-video)              转化站 (conversion-site)
┌────────────┐                  ┌─────────────────┐
│  国内轨     │  流量积累         │                 │
│ (抖音先)   │  ── 不直接绑死 ──→ │  ← 不绑死       │
│ Metric:流量│                  │                 │
├────────────┤                  │  独立网站 + AI 咨询│
│  国外轨     │  导流             │  国外付费为主    │
│ (待定)     │  ─── 主要导给 ───→ │  国内 backup    │
│ Metric:转化│                  │                 │
└────────────┘                  └─────────────────┘
```

详细战略地图见 [SETUP.md §4](SETUP.md)。

## 项目级 unique angle（两 part 都靠这个）

**用 AI 的运作机制解释人性现象**。
- LLM 思考模式 ≈ 人类思考模式（user 直觉 + 给别人讲课验证过）
- 这个赛道 user 说"并没有人做"
- 两 part 共用这个底层 framing：short-video 是表达层，conversion-site 是服务层

完整主导思想 / 护城河论证 → [SETUP.md §2-3](SETUP.md)。

## 项目级决策 log（顶级，跨 part）

| 日期 | 决策 | 出处 |
|---|---|---|
| 2026-05-25 | YoRHa-A2 立项作为 frame shift 后第一个交付项目 | NAISC 后 frame shift 对话 |
| 2026-05-25 | 主导思想 = 用 AI 机制解释人性 | 同 |
| 2026-05-25 | 项目分两 part：short-video（引流） + conversion-site（转化） | 本对话 |
| 2026-05-25 | 两 part 并行启动 | 本对话 |
| 2026-05-25 | claude-context 端拓扑 = 子目录式（part 独立 sub-MD） | 本对话 |
| 2026-05-25 | conversion-site 当前 concept，等 user 专题对话填 | 本对话 |
| 2026-05-25 | Vault 端重组对称：framework / drafts / published 已挪到 `short-video/` 子目录；YoRHa-A2 根只保留 README + SETUP + 两 part 子目录 | 立项后第二轮重组（user 直接指示，覆盖之前"暂不挪"的决策）|
| 2026-05-25 | Vault 端 README + SETUP + 各 part README 写满"想法 + 聊的东西"（不只是规约）| 同上 |

**part-specific 决策**写在各自 part 的状态板，不重复到这里。

## Claude 在本项目的职责

跟项目级 content mode 一致。详见 [SETUP.md §8](SETUP.md)。

一句话：**listener + 工具人，不在内容选题 / 商业框架 / 网站架构上 attack**（领域不熟，今天的对话已经 6 次试错全错）。

## Vault 工作区（已对称重组）

```
Vault/01 - Projects/YoRHa-A2/
├── README.md                    项目说明
├── SETUP.md                     Vault 端工作规约
├── short-video/
│   ├── README.md                想法 + 聊的东西
│   ├── framework/               v0 framework 4 文件
│   ├── drafts/
│   └── published/
└── conversion-site/
    └── README.md                想法 + 聊的东西
```

未来 conversion-site 长出自己的 framework / drafts 时，直接在 `conversion-site/` 下扩展（拓扑已对称）。

## 下一步（顶级，pending user）

- **short-video part**: 详见 [short-video/SHORT-VIDEO.md](short-video/SHORT-VIDEO.md) "下一步" 段
- **conversion-site part**: 详见 [conversion-site/CONVERSION-SITE.md](conversion-site/CONVERSION-SITE.md) "专题对话要解决的核心问题"

新增 part 或顶级 framing 变化 → 加进本文件决策 log。
