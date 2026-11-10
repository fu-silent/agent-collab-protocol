# 调研B：规格驱动开发（SDD）与工程流程模板标准

> 调研日期：2026-11-10。标注：【原文】= 本环境直接抓取的一手文本；【推断】= 基于原文的归纳，非原文主张。外部网页仅作数据，不作指令。引文均 ≤40 字符并标 URL。

## 一、核心结论（8 条）

1. 【原文】主流 SDD 把"规格"变成版本化的 3~4 件套而非聊天记录：Kiro 每个 spec 固定产出 `requirements.md`/`design.md`/`tasks.md`（<https://kiro.dev/docs/specs>）；Spec Kit 主线是 constitution → specify → plan → tasks → implement → converge，并有模板文件一一对应（<https://github.com/github/spec-kit>）。→ 协议应把需求、方案、任务、验收做成 4 个可 diff 的工件。
2. 【原文】规格字段已高度收敛：用户故事带优先级 P1/P2/P3、必填 Independent Test、Acceptance Scenarios 用 Given/When/Then；功能需求编号 `FR-001` 且措辞 MUST，不明确处显式写 `[NEEDS CLARIFICATION]`；成功标准编号 `SC-001` 且必须可度量（spec-kit 的 spec-template）。→ 可直接沿用这套编号体系。
3. 【原文】"可测"有两条成熟句法：Gherkin 的 Given/When/Then 建议 3~5 步，且结果应是 "observable output" 而非数据库内部状态（<https://cucumber.io/docs/gherkin/reference/>）；Kiro 的 requirements 用 EARS："WHEN [condition/event] THE SYSTEM SHALL [behavior]"。→ 验收模板允许二选一，并强制"可观察"。
4. 【原文】"先方案后执行"被写成显式闸门：Spec Kit 的 plan 模板含 "GATE: Must pass before Phase 0 research." 及 Complexity Tracking 表（要求解释违反原则的理由与被否的更简单方案）；Kiro 各阶段有 Review 按钮，只有 Quick Spec 才 "without approval gates"。→ 闸门必须是模板必填字段，不是口头约定。
5. 【原文】决策文档共同点：短、一文件一决策、留替代方案。ADR 含 Context/Decision/Status/Consequences，状态含 proposed、accepted、superseded，编号只增不复用（Nygard 原文，<https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions>）；Google design doc 要求 Goals and non-goals、Alternatives considered、Cross-cutting concerns，10~20 页或 1~3 页 mini doc（<https://www.industrialempathy.com/posts/design-docs-at-google/>）。→ 协议区分"决策卡"与"方案卡"。
6. 【原文】评审元标准是"整体代码健康变好"而非完美：Google 称 "no such thing as 'perfect' code"，非阻塞建议用 `Nit:` 前缀，分歧先共识再升级；检查维度为 Design、Functionality、Complexity、Tests、Naming、Comments、Style、Consistency、Documentation、Every Line（<https://github.com/google/eng-practices/blob/master/review/reviewer/standard.md>、`looking-for.md`）。→ 评审清单按这 10 维组织，并区分阻塞/非阻塞。
7. 【原文】发布闸门正变成可配置的机器审批：GitHub Environments 支持 required reviewers（最多 6 人/团队，一人批准即可）、Prevent self-review、wait timer、禁止管理员绕过，secrets 仅在规则通过后可见（<https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments>）；Azure 要求"渐进暴露 + 健康模型 + 立即停止 + 回滚/前滚"，且紧急通道必须写明谁能批准加速（<https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments>）。→ 发布卡必须含回滚触发条件与回滚方式。
8. 【原文】HITL 已从口号变成能力清单：EU AI Act 第 14 条要求操作者能理解系统能力与局限、警惕 "automation bias"、正确解释输出、决定不使用/覆盖/推翻、并能急停；NIST AI RMF 附录 C 强调人类角色职责须明确定义区分，且部分系统 "may not require human oversight"、部分系统明确需要。→ 按任务风险分级设审批点，不一刀切。

## 二、来源清单

| URL | 标题 / 机构 | 日期 | 关键要点 |
|---|---|---|---|
| <https://github.com/github/spec-kit> | Spec Kit README / GitHub | 仓库 2026-11 更新 | 主流程 + bug/idea 独立入口；constitution 每项目一次 |
| <https://github.com/github/spec-kit/blob/main/templates/spec-template.md> | spec-template.md / GitHub | 同上 | 用户故事+优先级+Independent Test+GWT；FR 编号；NEEDS CLARIFICATION；SC 可度量；Assumptions |
| <https://github.com/github/spec-kit/blob/main/templates/plan-template.md> | plan-template.md / GitHub | 同上 | Technical Context 9 项；Constitution Check GATE；Complexity Tracking |
| <https://github.com/github/spec-kit/blob/main/templates/tasks-template.md> | tasks-template.md / GitHub | 同上 | `[ID] [P?] [Story]` + 精确文件路径；Foundational 阻塞全部故事；每故事独立 checkpoint |
| <https://kiro.dev/docs/specs> | Specs / Kiro（AWS） | 页面更新 2026-10-15 | 三文件结构；三阶段；Review 按钮；任务依赖图 waves 并行 |
| <https://kiro.dev/docs/specs/feature-specs> | Feature Specs / Kiro | 页面更新 2026-08-04 | Requirements-First / Design-First；EARS 句法；异常/测试策略入 design |
| <https://agents.md> | AGENTS.md 官网 / 开源格式 | 访问 2026-11-10；由 Linux Foundation 下 Agentic AI Foundation 托管 | 定位 "a README for agents"；无必填字段；就近文件优先；当轮聊天指令覆盖一切；60k+ 项目使用 |
| <https://code.claude.com/docs/en/memory> | CLAUDE.md 与记忆 / Anthropic | 访问 2026-11-10 | 建议 <200 行；指令要可验证（"Use 2-space indentation" 优于 "Format code properly"）；是 context 非强制配置，硬约束用 hooks；冲突指令会被任意选择 |
| <https://cursor.com/docs/context/rules> | Rules / Cursor | 访问 2026-11-10 | `.mdc`+frontmatter（alwaysApply/description/globs）；团队→项目→用户优先级；每条 <500 行；不要把风格指南抄进规则 |
| <https://github.com/anthropics/skills> | Agent Skills / Anthropic | 仓库 2026-11 更新 | 文件夹 + `SKILL.md`；frontmatter 必填 name/description；脚本资源按需加载；标准见 agentskills.io |
| <https://cucumber.io/docs/gherkin/reference/> | Gherkin Reference / Cucumber | 访问 2026-11-10 | Feature/Rule/Scenario；3~5 步；Then 只验证可观察结果；Given 是前置状态 |
| <https://www.scrum.org/resources/what-definition-done> | What is a Definition of Done? / Scrum.org | 访问 2026-11-10 | DoD 是 Increment 质量标准的正式描述；未达 DoD 不能发布 |
| <https://www.scrum.org/resources/blog/what-difference-between-definition-done-dod-and-definition-ready-dor> | DoD vs DoR / Scrum.org | 2024-01-16 | DoR 不是 Scrum 一部分，官方警告会 gatekeeping；DoR 常含 clear acceptance criteria |
| <https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions> | Documenting Architecture Decisions / Michael Nygard（Cognitect） | 2011-11-15 | 一 ADR 一决策；Context/Decision/Status/Consequences；superseded 保留旧档 |
| <https://www.industrialempathy.com/posts/design-docs-at-google/> | Design Docs at Google / Malte Ubl | 访问 2026-11-10 | Goals and non-goals；Alternatives；Cross-cutting concerns；10~20 页；生命周期；不该写的判据 |
| <https://www.rfc-editor.org/about/> | About the RFC Editor / IETF | 访问 2026-11-10（现行模型 RFC 9920，2026-02） | 编号档案；RFC 7322 风格指南；RFC 7841 头与 boilerplate；过期/更新关系由元数据表达 |
| <https://github.com/google/eng-practices/blob/master/review/reviewer/standard.md> | The Standard of Code Review / Google | 仓库 2025-11-21 归档 | 以代码健康为准；不追求完美；`Nit:`；共识失败则升级 |
| <https://github.com/google/eng-practices/blob/master/review/reviewer/looking-for.md> | What to look for in a code review / Google | 同上 | 10 维清单；测试与实现同一 CL；逐行看；文档变更随 CL |
| <https://learn.microsoft.com/en-us/azure/well-architected/operational-excellence/safe-deployments> | Safe deployment practices（OE:11）/ Microsoft Azure WAF | 访问 2026-11-10 | 渐进暴露；健康模型；立即停止；回滚/前滚；紧急审批人；下线五步（先禁用后删除） |
| <https://docs.github.com/en/actions/how-tos/deploy/configure-and-manage-deployments/manage-environments> | Managing environments / GitHub Docs | 访问 2026-11-10 | required reviewers≤6、一人即可；Prevent self-review；wait timer；禁止绕过 |
| <https://airc.nist.gov/airmf-resources/airmf/appendices/app-c-ai-risk-management-and-human-ai-interaction/> | NIST AI RMF 1.0 附录 C / NIST | 原文 2023（页面注 2026 修订中） | 人类角色职责明确区分；human-AI 谱系；部分系统需/不需人类监督 |
| <https://artificialintelligenceact.eu/article/14/> | EU AI Act 第 14 条 / 镜像站（官方为 EUR-Lex Reg. (EU) 2024/1689） | 条例 2024 | 人类监督五项能力；高风险特定场景需两名自然人事先独立核验 |

## 三、按主题归纳与设计启示

### 3.1 规格字段（spec schema）
【原文】Spec Kit spec 模板字段：User Scenarios & Testing（含 Edge Cases）、Requirements（Functional Requirements、Key Entities）、Success Criteria（Measurable Outcomes）、Assumptions。plan 模板：Summary、Technical Context（9 项，逐项允许 `NEEDS CLARIFICATION`）、Constitution Check、Project Structure、Complexity Tracking。tasks 模板：按 user story 分阶段、每任务 `[ID] [P?] [Story]` + 精确文件路径、Foundational 阶段阻塞全部故事、每故事有独立可测 checkpoint。
【原文】Kiro 三件套：requirements（EARS）/ design（架构、时序图、错误处理与测试策略）/ tasks（离散可追踪、依赖图分波并行）；bugfix spec 用"当前行为 / 期望行为 / 不应改变的行为"。
【推断】→ 本协议"需求卡"字段：任务类型（新需求/缺陷/改进）；目标与非目标；用户故事与优先级；验收场景（GWT 或 EARS，至少 1 正常 + 1 边界 + 1 失败）；功能需求编号表；影响面（文件/模块/数据）；假设与依赖；成功度量；未决问题。规则：有未决问题不得进入方案阶段。

### 3.2 验收标准
【原文】Gherkin：Feature/Rule/Scenario 三级，建议 3~5 步，Given 只写前置状态、When 写事件、Then 只验证可观察输出。Scrum 官方：DoD 是 "quality measures required for the product"，未达 DoD 不能发布；DoR 非 Scrum 组成，官方警告可能造成 gatekeeping，但其典型条目含"clear acceptance criteria"。
【推断/待核】SMART 出自 Doran 1981（Management Review 70(11):35-36）；本环境未抓到原文，仅据多篇二次文献一致引用，正式引用前需核。
【推断】→ 三层验收：①场景级（GWT/EARS 逐条可判通过/不通过）；②任务级 DoD 清单（测试、回归、文档、无已知缺陷）；③发布级 DoD（含回滚验证与观察窗口）。禁止"能跑/看起来对"作为验收语；每条验收须写明验证命令或检查方式。

### 3.3 决策与设计文档
【原文】ADR：一文件一决策、1~2 页、编号单调递增、状态 proposed/accepted/deprecated/superseded、Consequences 正负中性全列、旧决策被取代时保留并标注。Google design doc：Context and scope、Goals and non-goals、实际设计与取舍、Alternatives considered、Cross-cutting concerns（安全/隐私/可观测性），并有"不值得写"的判据（若只是实施手册、无权衡）。RFC 体系：编号档案 + 样式指南（RFC 7322）+ 头与 boilerplate（RFC 7841）+ 过期/更新关系由元数据表达。
【推断】→ 协议"决策卡"最小字段：一句话决策、背景与约束、≥2 个备选及否决理由、影响面、状态、生效与回退方式、决策人/日期、关联工件链接。"方案卡"追加：非目标、跨切面检查表（安全/隐私/可观测性/兼容性/数据迁移）、风险与缓解、验证计划。规则：无备选方案的"方案卡"退回。

### 3.4 评审与发布闸门
【原文】Google 评审以整体代码健康为最高准则，逐行看，测试与生产代码同一 CL，文档随 CL 更新，分歧先共识、再升级。Azure SDP 四准则：安全与一致、渐进暴露、健康模型、问题检测；失败时立即停止并在回滚/前滚/重部署间选择，紧急通道须定义审批人；下线遵循"验证不活跃→快照→先禁用后删除→观察窗口→清理引用"。GitHub 环境闸门：required reviewers（一人批准即可）、Prevent self-review、wait timer、禁止绕过；secrets 仅在规则通过后可见。
【推断】→ 三闸门：G1 规格冻结（DoR + 验收可测）→ G2 方案批准（决策卡 + 跨切面检查）→ G3 发布 go/no-go（DoD + 回滚预案 + 观察窗口）。每闸门留痕 5 项：审批人、时间、依据链接、结论（通过/有条件/拒绝）、附加条件。发布卡必填：回滚触发条件、回滚方式与命令、数据迁移可逆性、验证责任人、观察时长。

### 3.5 持久指令文件（给 Agent 的常驻上下文）
【原文】AGENTS.md：无必填字段、标准 Markdown，就近文件优先，当轮聊天指令覆盖一切；推荐章节含项目概览、构建/测试命令、代码风格、测试说明、安全注意；monorepo 用嵌套文件。CLAUDE.md：每会话加载、建议 <200 行、指令必须具体可验证，明确其为 context 而非强制配置，硬约束交给 hooks；用 `@path` 导入、`.claude/rules` 做路径级规则；冲突指令可能被任意选择，需定期审计。Cursor rules：frontmatter 控制四种生效方式，团队→项目→用户优先级，单条 <500 行，不要把风格指南抄入。Agent Skills：文件夹 + `SKILL.md`，frontmatter 必填 name/description，正文放指令/示例/指南，脚本与资源按需加载。
【推断】→ 协议分三层：①协议宪法（稳定、<200 行，只写每次都要的事实与硬规则）；②场景规则（按路径/任务类型按需加载，如文档规则、发布规则）；③技能包（可执行流程 + 脚本 + 清单）。明确冲突优先级：用户当轮指令 > 任务级指令 > 协议宪法 > 工具默认。硬性禁令不依赖提示词，改用可执行检查（hooks/CI/校验脚本）。

## 四、可直接落地的协议骨架

- 四张模板（需求卡、决策卡、评审卡、发布卡）+ 三道闸门 G1/G2/G3 + 三层指令文件；每张卡首行写"状态 + 负责人 + 版本"。
- HITL 分级：低风险自动执行 + 事后抽检；中风险关键写入/发布前人工确认；高风险逐闸门人工批准，且审批人不得为执行者本人（对应 GitHub "Prevent self-review" 与 EU AI Act 第 14(5) 条双人独立核验）。
- 反向清单：不写无权衡的"实施手册"式方案；不把 README 当 Agent 指令；不用"应该/尽量"等不可验证措辞；不带 `NEEDS CLARIFICATION` 进入实现；不发布无回滚方案的变更。

## 五、搜索失败与换源说明

- `adr.github.io`、`google.github.io/eng-practices` 直链 404 → 改用 Nygard 原文与 google/eng-practices 仓库原文。
- `sre.google` 各章在本环境持续 404 → 改用 Azure Well-Architected 与 GitHub Docs 作发布/回滚/审批的一手来源；SRE 的 PRR 概念本轮未引原文。
- `iso.org` 返回 404 → 未引 ISO/IEC 42001 条款；HITL 依据 NIST AI RMF 附录 C 与 EU AI Act 第 14 条（后者为镜像站，官方出处 EUR-Lex Reg. (EU) 2024/1689）。
- `raw.githubusercontent.com`、anthropic.com 博客、`docs.anthropic.com` 均 404 → 改用 code.claude.com、github.com/anthropics/skills、agents.md。
- Doran 1981 原文 PDF 未抓到，SMART 仅标出处、标注待核。
