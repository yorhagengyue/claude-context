---
project: YoRHa-A2
sub-project: ai-interactive-story
type: 子项目速报
owner: Yufei (雨飞)
repo: https://github.com/toffemoon/ai-interactive-story (独立 repo · 卫星模式挂进 yorha-a2-team)
local: ~/Desktop/ai-interactive-story
status: 纯后端 API · 核心闭环已成
last-updated: 2026-06-02
upstream: ../YORHA-A2.md
working-mode: ../WORKING-MODE.md
---

# 子项目 · ai-interactive-story（AI 互动故事引擎）

> **一句话**：雨飞主导的 AI 互动故事引擎，纯后端 API。多角色卡 / 世界书 / 故事书 / 玩家卡 → 可玩的互动故事回合（叙事 + 角色发言 + 玩家选项 + 状态更新）。
>
> **owner**：雨飞。代码、引擎架构、产品功能由他主导（主理人判断雨飞架构判断力不足时，Claude 在该 repo 内当技术架构负责人、从 0 思考——见 §8 [2026-05-31] feedback）。它跟团队 / 最终目标的战略归属由主理人拍板。
>
> **repo 是独立的**：用"卫星模式"挂进团队（见 §8 satellite mount + repo 内 `CLAUDE.md`），不并进 claude-context。

## 现状（2026-06-02）

- **形态**：纯后端 FastAPI。原带 Vite/React 前端，因角色卡 spine 立绘渲染陷入排查黑洞（开发预览工具没 WebGL、验不了），2026-06-01 整个删掉，改纯后端；前端交调用方按 `/openapi.json` 自行实现。
- **技术栈**：Python 3.12 + FastAPI + DeepSeek（OpenAI 兼容）+ Supabase Postgres + pgvector + `bge-small-zh-v1.5` 向量记忆。
- **进度**：建卡 / 识别、卡库、故事预设、故事回合引擎（状态机 + 世界时钟 + 一致性自检 + 流式 SSE）、记忆两模式——核心闭环已成。
- **已知坑**：Supabase 免费实例闲置会被 pause，导致运行期连接卡住；`.env` 有 DeepSeek key + DB 连接串，永不读出 / 写进任何文件。

## 跟最终目标（咨询网站）的关系 —— 未定

引擎现在是**多角色互动故事游戏**；咨询网站要的"AI 接初接"是**咨询 intake 聊天**（把访客需求聊清 → 筛合格 lead → 交接真人）。两者产品形态差很大，重叠面窄（基本只有单角色对话 + 记忆 + 持久化那条）。

所以**故事引擎当前是雨飞主导的相对独立子项目，不等于"咨询网站的 AI 接初接实现"**。将来是否、以及如何把它（或其中的对话 / 记忆能力）接进咨询网站，等咨询网站那 8 个核心问题想清楚后再定；在那之前引擎按自己的路线走。

## 治理（卫星模式）

- 工程决策放引擎 repo 自己的 `decisions/`；它跟团队 / 最终目标的战略关系放 team repo `yorha-a2-team/decisions/`。
- 引擎 repo 根有自己的 `CLAUDE.md`（双帽子：给 repo 写代码 + 守团队治理）。
- ⚠️ 那份 CLAUDE.md 假设父 repo clone 在 `~/Desktop/yorha-a2-team`。本机若没 clone，"写 team-log 回父 repo"那条会空转——要么 clone 下来，要么改它指到实际位置。

## 详情

引擎自己的架构 / 路线在它的 repo 内（`README.md` + `decisions/` + `docs/`）。本文件只是 YoRHa-A2 视角的子项目指针，不重复引擎内部细节。
