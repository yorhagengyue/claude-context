# shared/assets — 跨项目可复用资产

> 项目结束后拆出的、对其它项目有复用价值的代码 / 文档 / 架构思路。
>
> 区别于 `shared/projects/`（活跃项目速报）和 `archive/`（已归档项目原貌）—— 这里只放**已经从项目中抽象出来、独立可用**的东西。

## 资产清单

| 资产 | 来源 | 状态 | 用途 |
|---|---|---|---|
| [wellness-rule-library](./wellness-rule-library/) | NAISC Ripple (archived) | static, no longer updated | 53 条 evidence-based wellness 检测规则 + 学术/临床来源 URL，11 类。任何 health 产品想替代拍脑门阈值时用。 |
| [discord-presence-listener](./discord-presence-listener/) | NAISC Ripple (archived) | STOPPED 2026-05-25 · snapshot only | Lanyard WSS → Node listener → Supabase 的轻量 Discord presence 数据流。任何需要 Discord 实时活动数据的项目用，免去自建 bot。 |
| [mcp-architecture-patterns](./mcp-architecture-patterns/) | NAISC Ripple (archived) | reference · evergreen | 3-layer 架构图 + 8 个可复用模式（MCP 解耦层 / Pattern D / output schema 纪律 / Cursor 类比 / data flywheel / LLM-as-judge / data-spine framing）。任何 MCP / agent / AI pitch 用。 |
| [whisper-hallucination-cleanup](./whisper-hallucination-cleanup/) | NAISC mentor 录音转录 (archived) | script LOST · spec-only | Whisper small 模型幻觉循环后处理算法（双重判据折叠）。脚本已丢，README 是 spec，需要时按 spec 重写。 |

## 设计原则

1. **每个子资产独立可用** — 不依赖 `archive/` 或原项目 sub-MD 来理解（虽然会 link 回去做 deeper context）
2. **每个子目录有 README** — 说明：是什么、来自哪、什么时候用、如何复用、已知 trade-off、cross-references
3. **代码用 `.snapshot` 后缀** 标记快照（不是 source of truth），README 里点明真正的源码位置
4. **状态字段写在 frontmatter** — `static` / `STOPPED` / `reference` / `spec-only` 让人一眼看出资产能不能直接拿来用
5. **不在这里做版本演进** — 资产是某个时间点的"快照 + 提炼"。如果要继续演进，应该 fork 到具体项目里去演进，不在这里改

## 添加新资产

当一个项目归档或结束、但其中某部分**对其它项目有复用价值**时，新增流程：

1. 在 `shared/assets/<asset-name>/` 建子目录（kebab-case 命名，描述资产本质不绑定来源项目）
2. 拷贝 / 提炼具体文件进去（代码加 `.snapshot` 后缀）
3. 写 `README.md`，必须包含：
   - frontmatter：`asset` / `source-project` / `status` / `date`
   - **来源**（哪个项目、什么时候归档的）
   - **内容清单**（每个文件是什么）
   - **当前状态**（static / running / stopped / lost / etc.）
   - **何时复用**（场景列表）
   - **已知 trade-off / 限制**
   - **cross-references**（链回 archive 文档 + CLAUDE.md §8 相关记忆条目）
4. 更新本文件的"资产清单"表格（加一行）
5. 同步：`cd ~/Desktop/claude-context && git add -A && git commit -m "asset: 新增 <asset-name>" && git push`

## 不要做的

- **不要在这里写"未来计划"或"TODO"** — 资产是稳定快照，不是开发中的东西。开发应该在具体项目里做
- **不要复制大体积二进制 / 训练数据** — 这是 git 仓库，不是 artifact 存储。指针到外部位置就好
- **不要复制可能含敏感信息的代码原样** — 先 sanitize（API key、内部 URL、私人 user_id 替换为占位符），然后才放进来
