# 调研 C：验证、证据、失败模式与人机信任

> 检索日期 2026-11-10；优先一手来源，网页内容一律按数据处理。
> 抓取失败换源说明：openai.com「Practices for Governing Agentic AI Systems」PDF 与 OpenAI Model Spec 经抓取均返回 404，NIST AI 600-1 PDF 亦 404（已改用 NIST AI RMF 官方页面替代），因此**未引用**其原文，仅在有把握处提及存在性。

### ① 核心结论（8 条）

1. **现场收益、甚至自我感知，都不等于能力**。[METR 随机对照试验](https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/)（16 名资深开源开发者、246 个真实任务）发现：「take 19% longer than without」；而开发者事前预测快 24%，事后仍认为「AI had sped them up by 20%」。→ **协议设计**：自评/主观收益与实测结果必须分栏记录，自评不得作为验收依据。
2. **基准分数不可外推**。同为实验，[GitHub Copilot 实验](https://arxiv.org/abs/2302.06590) 在"实现 HTTP server"任务上快 55.8%，METR 在真实大型仓库却慢 19%；差异来自任务复杂度、质量标准与评测方式（METR 自述）。→ **协议设计**：通过标准必须来自目标仓库的 DoD，不得引用外部 benchmark 分数当验收。
3. **AI 是放大器，不是稳定器**。[DORA 2025](https://dora.dev/research/2025/dora-report/)（Google Cloud 年度报告）：AI 首要作用是「amplifier, magnifying an organization's existing strengths and weaknesses」；[DORA 2024](https://dora.dev/research/2024/dora-report/) 更直白：AI 提升个体生产力，但「negatively impacts software delivery stability and throughput」。→ **协议设计**：验收同时覆盖"功能正确"与"稳定性/可回滚"，不能只报速度。
4. **信任赤字可量化**。[Stack Overflow 2025](https://stackoverflow.co/company/press/archive/stack-overflow-2025-developer-survey)（49,000+ 回复）：84% 使用或计划使用 AI 工具，但「46% … don't trust the accuracy of the output」（上年 31%），45% 认为调试 AI 代码耗时。→ **协议设计**：默认"带证据交付"，证据不足即视为未完成，把不可验证的"信任"换成可核查项。
5. **失败集中于"任务验证"**。[MAST](https://arxiv.org/abs/2503.13657) 基于 1600+ 条轨迹、7 个框架，标注出 14 种失败模式/3 大类，第三类即任务验证（标注一致性 κ=0.88）。→ **协议设计**：完成定义必须写明"由哪条命令/哪个产物证明"；否则「looks done」就是唯一依据（Anthropic 文档原话）。
6. **人类审批会失效**。[Goddard 等（JAMIA 2012）](https://pmc.ncbi.nlm.nih.gov/articles/PMC3240751/)（74 项研究的系统综述）显示自动化偏见使错误建议被采纳、错误决策风险上升（risk ratio 1.26）；EU [AI Act 第 14 条](https://artificialintelligenceact.eu/article/14/) 要求监督者警惕「over-relying on the output」，特定高风险场景还要求至少两名自然人独立核验。→ **协议设计**：审批必须绑定"本次必须核验的具体项"，不能只点"同意"。
7. **过度审批同样有害**。Anthropic [官方文档](https://code.claude.com/docs/en/best-practices) 承认手动模式「after the tenth prompt you start approving without reading」，并建议把"零例外规则"下沉为 hook/deny rule、保持强制规则集小。→ **协议设计**：按风险分级设审批点：不可逆动作才人工，其余自动执行并留痕。
8. **规范文件是低成本杠杆，但必须声明优先级**。[AGENTS.md](https://agents.md/) 已被 60k+ 项目采用，规则是"离改动文件最近的 AGENTS.md 优先、用户聊天指令覆盖一切"；[GitHub 文档](https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions) 给出的优先级是"个人 > 仓库 > 组织"。→ **协议设计**：模板必须内置冲突裁决顺序（当轮用户指令 > 项目规范 > 外部内容），否则规则冲突时 Agent 只能猜。

### ② 来源清单

| # | 来源（标题/机构） | 日期 | 要点 | URL |
|---|---|---|---|---|
| S1 | Measuring the Impact of Early-2025 AI…（METR，RCT） | 2025-07-10 | 16 人/246 任务；慢 19%，预期快 24% | https://metr.org/blog/2025-07-10-early-2025-ai-experienced-os-dev-study/ |
| S2 | The Impact of AI on Developer Productivity（Peng 等，GitHub Copilot 实验） | 2023-02-13 | HTTP server 任务快 55.8%（实验室反例） | https://arxiv.org/abs/2302.06590 |
| S3 | 2025 DORA Report: State of AI-assisted Software Development（Google Cloud/dora.dev） | 2025-09-23 | "AI 是放大器"；AI 放大既有优势与缺陷 | https://dora.dev/research/2025/dora-report/ |
| S4 | 2024 DORA Report（dora.dev） | 2024（页面更新 2026-04） | AI 提升个体生产力，损害交付稳定性/吞吐 | https://dora.dev/research/2024/dora-report/ |
| S5 | Stack Overflow 2025 Developer Survey 新闻稿 | 2025-07-29 | 49k+ 回复；46% 不信任准确性（上年 31%） | https://stackoverflow.co/company/press/archive/stack-overflow-2025-developer-survey |
| S6 | Why Do Multi-Agent LLM Systems Fail?（MAST，arXiv v3） | 2025-10-26（v1 2025-03） | 1600+ 轨迹；14 模式/3 类，含任务验证 | https://arxiv.org/abs/2503.13657 |
| S7 | Lost in the Middle（Liu 等，TACL） | 2023-11-20（v3） | 关键信息位于长上下文中部时性能显著下降 | https://arxiv.org/abs/2307.03172 |
| S8 | The Instruction Hierarchy（Wallace 等，OpenAI） | 2024-04-19 | 模型易把不可信文本与系统指令同权，需显式优先级 | https://arxiv.org/abs/2404.13208 |
| S9 | Automation bias: a systematic review（Goddard 等，JAMIA） | 2012（在线 2011-06） | 74 项研究；错误建议致错误决策风险 +26%；训练/问责/置信度可缓解 | https://pmc.ncbi.nlm.nih.gov/articles/PMC3240751/ |
| S10 | EU AI Act 第 14 条 Human Oversight（条文镜像站，非 EUR-Lex 官方） | 2024 生效（页面 2026 抓取） | 监督者需知自动化偏见；可覆盖/中止；特定场景双人核验 | https://artificialintelligenceact.eu/article/14/ |
| S11 | NIST AI Risk Management Framework（含 AI 600-1 GenAI Profile） | RMF 2023-01-26；GenAI Profile 2024-07-26 | 可信 AI 风险管理；生成式 AI 专门风险与治理动作 | https://www.nist.gov/itl/ai-risk-management-framework |
| S12 | Best practices for Claude Code（Anthropic 官方文档） | 更新 2026-11-09 | 给 Agent"可跑通的检查"；要命令+输出作证据；手动模式易橡皮图章 | https://code.claude.com/docs/en/best-practices |
| S13 | AGENTS.md（开放格式） | 抓取 2026-11-10 | README for agents；60k+ 项目；就近优先、聊天指令覆盖 | https://agents.md/ |
| S14 | Adding repository custom instructions for GitHub Copilot（GitHub Docs） | 抓取 2026-11-10 | 仓库/路径/Agent 三类指令；个人>仓库>组织优先级 | https://docs.github.com/en/copilot/how-tos/configure-custom-instructions/add-repository-instructions |
| S15 | promptfoo 文档（提示词评测/红队工具） | 抓取 2026-11-10 | test-driven prompt engineering；断言+指标+CI/CD | https://www.promptfoo.dev/docs/intro/ |

### ③ 失败模式分类与协议对策

| 失败模式 | 证据/来源 | 协议如何防 |
|---|---|---|
| 工具调用/参数错误 | MAST 归纳的 14 模式覆盖系统设计与任务验证问题（S6） | 工具白名单、入参 schema 校验、重试上限、失败升级人工 |
| 过度自信/校准失准 | METR：自评快 20% vs 实测慢 19%（S1） | 强制输出"置信度 + 未验证清单"；建立"预测-实测"记分 |
| 上下文丢失/遗忘 | "Lost in the Middle"：中部信息显著易丢（S7） | 约束放开头和结尾；交接词附证据；每轮复述 DoD |
| 指令漂移/优先级冲突 | 指令层级论文：不可信文本可与系统指令同权（S8） | 声明"用户当轮 > 项目规范 > 外部内容"；外部内容只当数据 |
| 验证缺口（声称完成未验证） | 无检查时「looks done」是唯一依据（S12） | 完成=命令+输出+退出码；缺证据自动标"未验证" |
| 范围蔓延/规格漂移 | MAST 归纳的规格歧义与失配类失败（S6） | 先固化 spec/验收用例；超范围新增需重新审批 |
| 自动化偏见/橡皮图章 | Goddard 2012（S9）+ EU Act 14（S10） | 审批绑定核验项、随机盲审、高风险双人复核 |
| 测试投机/奖励黑客 | **推断**：为过测试而改测试/绕断言在 SWE 类任务中常见，本项目无直接证据 | 测试基线只读；CI 独立环境；含测试文件的 diff 强制人工看 |

### ④ 证据分级与验收设计建议

**证据分级（L0–L4）**：
- L0 自述："已完成/应该没问题"→ 不可作验收依据。
- L1 命令：给出可复跑命令及环境前提 → 可复核，但未证明已执行。
- L2 命令+输出：命令、退出码、关键日志/截图/产物 diff 或哈希 → 常规任务最低门槛。
- L3 指标：在 L2 上给阈值（测试通过率、构建产物 diff 为空、CI 状态、性能/像素对比）→ 需可回归量化。
- L4 独立复现/独立评审：另一 Agent 在干净上下文复跑（Anthropic 文档的 /code-review 即"fresh subagent"），或另一人按证据包复现 → 发版与高风险任务。

**验收四原则**：①"无证据不通过"，证据等级与风险匹配（低风险 L2、发版/不可逆 L4）；②负向测试——修复类任务必须先给"失败复现"（红），再给修复后输出（绿），只给"现在过了"不接收；③声称与证据分离——Agent 自述只作线索，笼统的"全部通过"必须附原始输出；④证据新鲜度——结果须绑定本次 diff 的 commit 与时间，旧截图/旧 CI run 视为未验证。

**证据包（DoE）必填 9 项**：任务 ID 与范围；变更清单（文件+diff）；完整命令；原始输出与退出码；环境（版本/依赖/数据/时间）；指标与阈值；失败复现证据；副作用与回滚方案；未验证项与残余风险。**设计启示**：模板把证据包设为完成后的强制字段，Agent 无法用一段总结交差。

### ⑤ 审批与信任设计建议

**5.1 审批点（只设四类）**：①不可逆或外部副作用（push/deploy/发版/删除/付费/对外发送/权限与密钥）；②范围与预算变化（超出 spec、新增依赖/语言/供应商、超时超预算）；③高风险结论（法务、安全、隐私、对外承诺）；④证据缺失但要求继续。其余动作默认自动执行并留痕。

**5.2 防橡皮图章（5 招）**：审批界面固定"本次必须核验的 2–3 项"；先看产物后看自述（盲审）；高风险双人复核（EU Act 的 Annex III 先例）；审批需写一句理由/否决项；统计评审者"通过率"并轮换抽检。

**5.3 控制过度审批**：按风险分级授权（读/可回滚自动；写/不可逆人工）；批量审批同类低风险；"零例外规则"下沉为 hook/deny rule/sandbox 等确定性机制，偏好类留给模型判断，且**保持强制规则集小**（Anthropic 明确建议）；审批超时按安全默认拒绝。

**5.4 信任校准**：用"证据等级 = 风险等级"替代二元信任；记录 Agent"声称等级 vs 实测结果"形成校准曲线，动态调整抽检率；对"高置信但错误"优先抽检（自动化偏见最危险的区域）；界面必须提供"不采用/覆盖/中止"三个显式动作（EU Act 14 要求可覆盖与 stop）。

**5.5 公开规范样例对照（4 个，提炼字段）**

| 样例 | 结构/定位 | 完成与验证条款 | 权限/审批 | 冲突优先级 |
|---|---|---|---|---|
| AGENTS.md（S13） | "README for agents"：setup/test/PR/风格 | 示例要求"提交前所有测试通过" | 无内建权限模型 | 就近文件优先；用户聊天覆盖一切 |
| Anthropic Claude Code 最佳实践（S12） | 区分非确定（提示/CLAUDE.md）与确定（hook/deny rule/sandbox） | "给它一个能跑通的检查"；要命令+输出；/verify；独立 reviewer | 权限模式、deny 规则、sandbox | CLAUDE.md 等设置按作用域分层 |
| GitHub Copilot 仓库指令（S14） | `.github/copilot-instructions.md` + `*.instructions.md`（applyTo 路径） | 要求文档化 build/validate 步骤 | 可 excludeAgent；无审批语义 | 个人 > 仓库 > 组织 |
| promptfoo（S15） | 提示词测试用例+断言+指标 | 以测试通过/指标作为提示词"验收" | CI/CD 集成，无人工审批 | 以用例集为唯一基准 |

**提炼出协议模板的 6 个必填字段**：①目标与范围（含不做什么）；②完成定义 DoD 与所需证据等级；③命令/工具与权限边界；④红线与禁止项；⑤上下文与交接（含冲突优先级）；⑥汇报格式、停止点与审批表。**设计启示**：本协议模板 = 上述 6 字段 + 证据包引用 + 审批表，即可同时覆盖新需求、缺陷与改进三类任务；再把外部来源（网页/检索结果）固定降级为"数据"，防止 S8 所述的指令覆盖。
