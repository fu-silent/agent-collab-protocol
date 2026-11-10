# 通用人机协作协议（CGE v1.1）· 工具包

> 仓库：<https://github.com/fu-silent/agent-collab-protocol> ｜ 许可：MIT ｜ 版本：v1.1（2026-11-10）

一套**放之四海而皆准**的人机协作方法：把"把活交给智能体"变成可复制的流程——
**任务契约（Contract）→ 按风险过闸（Gates）→ 用证据验收（Evidence）**。

适用：新需求、缺陷、改进/重构、评审、发布、调研、文档、运营事务；跨项目、跨模型、跨 Agent 工具。

## 30 秒认识它

- 问题：提示词缺验收、范围不封口、授权靠猜、"完成"没证据、规则留在聊天里。
- 解法：四件产物（契约 / 决策 / 证据报告 / 交接与规范）+ 六道闸门（G0–G5）+ G6 沉淀 + 风险四级 + 证据五级。
- 上手：先用 `templates/01-任务契约.md` 写一次；用 `templates/12-提示词完整度评分卡.md` 自检。

## 文件地图

| 文件 | 用途 | 什么时候看 |
|---|---|---|
| [`通用人机协作协议.md`](通用人机协作协议.md) | 主手册（约 1200 行）：原理、协议、闸门、证据、反模式、落地、参考来源 | 完整阅读/查表 |
| [`templates/01-任务契约.md`](templates/01-任务契约.md) | 通用任务契约（14 必填 + 6 条件） | 每次任务 |
| [`templates/02-新需求任务单.md`](templates/02-新需求任务单.md) | 规格先行（Spec-First） | 新功能/新页面 |
| [`templates/03-缺陷报告单.md`](templates/03-缺陷报告单.md) | 复现 → 红 → 修 → 绿 | bug/回归 |
| [`templates/04-改进重构迁移单.md`](templates/04-改进重构迁移单.md) | 不变量 + 基线 + 回滚 | 重构/迁移 |
| [`templates/05-审查请求与批注单.md`](templates/05-审查请求与批注单.md) | 只读审查 + 编号批注 | 代码/文档/方案评审 |
| [`templates/06-方案决策记录.md`](templates/06-方案决策记录.md) | ADR-lite：一决策一文件 | R2+ 方案 |
| [`templates/07-发布上线清单.md`](templates/07-发布上线清单.md) | go/no-go + 回滚 + 事后核对 | 发布/上线 |
| [`templates/08-交接提示词.md`](templates/08-交接提示词.md) | 八字段：证据包 + 免复查 | 长会话/换人 |
| [`templates/09-调研可行性时间盒.md`](templates/09-调研可行性时间盒.md) | 决策备忘，不改生产 | 不确定性高 |
| [`templates/10-验收证据报告.md`](templates/10-验收证据报告.md) | 逐条对账 + 证据包 + 未验证项 | 每次交付 |
| [`templates/11-项目Agent指令模板.md`](templates/11-项目Agent指令模板.md) | 项目持久规则/命令/红线 | 项目初始化 |
| [`templates/12-提示词完整度评分卡.md`](templates/12-提示词完整度评分卡.md) | 20 项评分 + 一分钟 8 问 | 发任务前 |
| [`skill/agent-collab-protocol/SKILL.md`](skill/agent-collab-protocol/SKILL.md) | Agent 侧技能（可安装到 DSH 用户目录） | 安装/分发 |
| [`assets/cge-protocol-one-page.png`](assets/cge-protocol-one-page.png) | 一页速查图（契约/闸门/风险/证据/铁律/8 问） | 打印/分享 |
| [`assets/cge-protocol-one-page.pdf`](assets/cge-protocol-one-page.pdf) | 同上 PDF（文本可复制，适合打印） | 打印/分发 |
| [`install.sh`](install.sh) | 一键安装/更新用户级技能 | 首次安装 |
| [`research/`](research/) | 调研原文与红队评审记录（A 提示词/ B 规格流程/ C 验证信任/ 红队 v1.0） | 查证据/复审 |
| [`CHANGELOG.md`](CHANGELOG.md) | 版本变更记录 | 了解演进 |
| [`LICENSE`](LICENSE) | MIT 许可证 | 复用/分发 |

## 三种使用方式

### 1) 人读（最常用）

1. 先读主手册 §0 + §2（约 15 分钟）；再读 §3 + §5（约 45 分钟）。
2. 打开 `templates/01-任务契约.md`，复制填空。
3. 交付时用 `templates/10-验收证据报告.md` 对账；长期任务用模板 08 交接。

### 2) Agent 用（安装技能）

```bash
git clone https://github.com/fu-silent/agent-collab-protocol.git
cd agent-collab-protocol && ./install.sh
# 安装到 ~/.dsh/skills/agent-collab-protocol/（可用 DSH_HOME 覆盖）
```

> 已在当前机器安装过；更新时 `git pull && ./install.sh` 即可。

安装后，在任何项目里让 Agent 处理非平凡任务时，技能会被自动匹配加载；也可显式说"加载 agent-collab-protocol 技能"。
技能内置：契约、闸门、证据、授权、交接、反模式；并按需读取随包模板。

### 3) 项目固化（写进仓库）

把 `templates/11-项目Agent指令模板.md` 填好放到项目根目录 `AGENTS.md`；
长期规则进 AGENTS.md，方法进技能，任务细节进提示词，状态进交接词（见手册 §10.1）。

## 设计依据（摘要）

- **验证缺口**：METR 2025 RCT（16 人/246 任务）显示用 AI 反而慢 19%，而自评以为快 20%；MAST 多智能体失败分类把"任务验证"列为核心失败类。
- **失败成本**：DORA 2024/2025 指出 AI 放大既有优势与缺陷、损害交付稳定性；Stack Overflow 2025 中 46% 不信任 AI 输出。
- **成熟实践**：Spec Kit/Kiro 的规格驱动、Scrum DoD、ADR、Google 评审与设计文档、GitHub/Azure 发布闸门、NIST/EU AI Act 人类监督、AGENTS.md/CLAUDE.md/Cursor/Skills 持久指令。
- 详细来源见主手册附录 C（40+ 一手链接）。

## 版本与维护

- 版本：v1.1（2026-11-10；按红队评审修订字段口径、证据阶梯、闸门矩阵与治理规则）。
- 修改流程见主手册 §10.7：提议 → 影响面 → 试点 → 评审 → 发布 → 同步技能与模板。
- 模板与技能保持同源：`install.sh` 会先把本目录 `templates/` 同步进技能包，再安装到用户目录，避免两处副本漂移。

## 许可与致谢

本工具包以 **MIT** 许可发布，可自由用于团队内部与公开分享；引用外部框架时已在主手册附录 C 标注来源与链接。
