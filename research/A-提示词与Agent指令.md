# 调研 A：提示词工程与 Agent 指令的权威实践

> 访问日期统一为 2026-11-10。标注规则：【原文】= 官方原文短引（≤40 字，标 URL）；【推断】= 本调研的归纳，非原文。抓取说明：docs.claude.com 有区域限制、platform.openai.com 被 Cloudflare 拦截，这两处改用官方 GitHub/官方 Cookbook 原文与 reader 镜像，其余为一手原文直取。

## ① 核心结论

1. **指令结构优先于措辞**：三家官方一致要求把提示词拆成固定分区——身份/背景、指令、上下文数据、示例、输出格式——并用 XML 标签或 Markdown 标题分隔（Anthropic、OpenAI、Google、阿里云皆同）。
2. **上下文是有限预算而非免费容量**：token 越多召回越差（context rot），官方目标是"最小高信号 token 集"，靠分层披露、压缩、结构化笔记、子代理来管理。
3. **硬约束必须出提示词**：Anthropic 明确区分「模型自行决定」（prompt/CLAUDE.md/skill）与「harness 强制执行」（hook/deny rule/CI）；提示词写得再重，仍由模型决定是否遵守。
4. **验收必须可执行、带证据**：最佳实践要求给 Agent 一个能运行的检查，并要求回报"命令 + 输出/截图"；否则"看起来完成"就是唯一依据。
5. **矛盾指令的代价随模型能力上升**：OpenAI 指出 GPT-5 遇到矛盾/模糊指令会消耗推理 token 去调和，必须先做矛盾审查再上线。
6. **Agent 指令要显式定义自主度、停止条件、交接条件**：OpenAI 用 reasoning_effort + 提示词控制 agentic eagerness，并要求写清 stop conditions、safe/unsafe actions、何时交回用户；Google 的 agentic system instruction 模板要求行动前先规划并逐条引用依据。
7. **工具描述就是接口契约**：Anthropic 把工具定义为"确定性系统与非确定性 Agent 之间的契约"，要求 token 高效返回、命名空间、合并工具、以测评驱动改进。
8. **可复用模板的最小原子是 Skill 式包**：YAML 元数据（name/description）+ 正文 + 按需加载的附加文件，metadata 常驻、正文与附件按需读取。

## ② 来源清单

| URL | 标题/机构 | 日期 | 关键要点 |
|---|---|---|---|
| https://www.anthropic.com/engineering/effective-context-engineering-for-ai-agents | Effective context engineering for AI agents / Anthropic | 2025-09-29 | context rot、注意力预算、分区化 system prompt、JIT 检索、压缩/笔记/子代理 |
| https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills | Equipping agents for the real world with Agent Skills / Anthropic | 2025-10-16 | SKILL.md + YAML frontmatter；三级 progressive disclosure；评估驱动编写 |
| https://www.anthropic.com/engineering/writing-tools-for-agents | Writing effective tools for agents / Anthropic | 2025-09-11 | 工具即契约；合并工具；命名空间；token 高效返回；测评与工具指标 |
| https://www.anthropic.com/engineering/claude-code-best-practices | Best practices for Claude Code / Anthropic | 持续更新（无页面日期） | 确定性 vs 非确定性指令；CLAUDE.md 只写仓库里看不到的；证据验收；skill 比 CLAUDE.md 省 context |
| https://github.com/anthropics/prompt-eng-interactive-tutorial | Anthropic Prompt Engineering 交互教程 / Anthropic 官方 GitHub | 2024（持续更新） | 基础结构、清晰直接、角色、数据与指令分隔、分步思考、示例、防幻觉 |
| https://cookbook.openai.com/examples/gpt-5/gpt-5_prompting_guide | GPT-5 prompting guide / OpenAI Cookbook | 2025 初版，持续更新 | 自主度调节、stop 条件、矛盾指令审查、元提示、工具前导语、verbosity |
| https://platform.openai.com/docs/guides/prompt-engineering（镜像：https://r.jina.ai/https://platform.openai.com/docs/guides/prompt-engineering） | Prompt engineering / OpenAI | 持续更新 | 消息角色与权威层级（developer>user）、Markdown/XML 分区、context 放末尾、RAG、prompt caching |
| https://ai.google.dev/gemini-api/docs/prompting-strategies（解析至 https://aistudio.google.com/docs/prompting-strategies.md） | Prompt design strategies / Google | 持续更新 | 清晰具体、约束、输出格式、上下文放前指令放后、组件化/链式、agentic 模板 |
| https://ai.google.dev/gemini-api/docs/prompting-strategies → https://cloud.google.com/vertex-ai/generative-ai/docs/learn/prompts/prompt-design-strategies | Prompt design strategies / Google Cloud Vertex AI | 持续更新 | 同一套最佳实践的 GCP 官方版本（可核对、可长期引用） |
| https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/prompt-engineering | Prompt engineering techniques / Microsoft | 持续更新 | prompt 组件=instructions+primary content+cues；明言旧技巧不推荐用于 reasoning 模型 |
| https://docs.aws.amazon.com/bedrock/latest/userguide/prompt-engineering-guidelines.html | Prompt engineering guidelines / AWS Bedrock | 持续更新 | 提示词优化、RAG 降幻觉、按模型族取各自官方 prompt guide |
| https://arxiv.org/abs/2406.06608 | The Prompt Report: A Systematic Survey / Schulhoff et al. | v1 2024-06-06，v6 2025-02-26 | 33 术语、58 种文本提示技术 + 40 种多模态；提示词细节敏感性；工程需与领域专家协作 |
| https://help.aliyun.com/zh/model-studio/prompt-engineering-guide | Prompt 工程指南 / 阿里云百炼官方文档 | 持续更新 | Prompt 框架（目的/风格/语气/受众/输出）、输出样例、分隔符、思维链、提示链 |

## ③ 分主题归纳与设计启示

### 3.1 指令结构要素
- 【原文】"organizing prompts into distinct sections (like `<background_information>`, `<instructions>`, `## Tool guidance`, `## Output description`)"（context engineering URL）。Google 补充：关键行为约束与输出格式放 System Instruction 或提示词最前；长上下文时"context 在前、具体指令在最后"，并用一句过渡语锚定（"Based on the information above..."）。
- 【原文】system prompt 要落在"right altitude"：既非硬编码的脆弱 if-else，也非含糊的高层建议。
- 【推断】协议模板应固定 8 个字段：`goal / inputs(带分隔符) / constraints(硬+软) / steps / output_contract / acceptance(DoD) / stop & handoff / examples`。阿里云"目的-风格-语气-受众-输出"框架可并作 `output_contract` 的细化子字段。

### 3.2 上下文工程
- 【原文】"find the smallest possible set of high-signal tokens"（URL）；上下文"must be treated as a finite resource with diminishing marginal returns"。
- 手段：JIT 按引用加载（文件路径/查询/链接，而非全文粘贴）、三级披露（索引→正文→附件）、compaction 压缩、NOTES.md/todo 结构化笔记、子代理隔离探索并只回传摘要。【推断】协议里应加"上下文预算"字段与"何时压缩/落盘"的触发条件。
- 【原文】"Only write down what Claude can't find by reading the repo"（Claude Code URL）——上下文不是越多越好，重复可得信息是噪声。
- 长上下文顺序（Google）：先给全部资料，再把问题放在末尾；OpenAI 同样建议 context 靠近末尾。

### 3.3 约束与验收
- 把规则分三层：【原文】non-deterministic（模型可决定不做）vs deterministic（harness 每次执行）；"A prompt alone can't guarantee"（Claude Code URL）。【推断】协议应给出"规则分层表"：必须永远发生/永不发生的 → hook/CI/deny/审批；偏好 → 提示词；一次性事实 → 上下文引用。
- 验收=可执行检查+证据：测试/typecheck/CI/Stop hook，"ask Claude for evidence: the command it ran and its output"。
- 停止与升级：GPT-5 指南要求写清 stop conditions、安全/不安全动作、何时交回用户；不同风险工具设不同不确定性阈值（如支付需确认、搜索可自行决断）。
- 硬冲突处理：Gemini agentic 模板给出优先级——政策/强制前提 > 操作顺序 > 其他前提 > 用户偏好；并要求"引用原文依据"做 grounding。
- 迭代而非一次成型：Prompt Report 指出提示词对细节高度敏感、等价改写可致显著性能差异；官方指南均称 prompt engineering 是迭代过程。

### 3.4 Agent 与工具使用
- 工具契约：清晰且互不重叠的用途、合并多步骤为单工具、返回精炼结果、命名空间前缀。【推断】协议的工具调用规范应要求"每次调用可解释其目的与预期返回"，并记录工具/token/耗时/错误指标。
- 探索预算：GPT-5 的 `<context_gathering>` 给出可移植范式——目标、方法、早停条件（能点名要改的内容/命中收敛 70%）、深度限制、循环。
- 自主度档位：【推断】协议模板应参数化 `autonomy_level`（lean/standard/thorough）+ `tool_budget` + `handoff_rule`，而非一个固定提示词。

### 3.5 常见误区
- 靠加粗/强调词强推规则，而不落到确定性执行。
- 把仓库里已有的信息重复写进指令，挤占注意力。
- 指令互相矛盾（尤其多来源拼装的 prompt），推理型模型反而更受伤。
- 示例贪多而不 canonical（应少量、多样、覆盖典型路径）。
- 缺少停止条件、升级路径、最大轮次/预算。
- 把"think step by step"当开关：Claude 官方说明它只是普通提示文本，真正的强度由 effort 档位控制。
- 跨模型直接套用旧技巧：Azure 明言其部分技巧不推荐用于 reasoning 模型；Gemini 3 默认简洁，需显式要求详细。
- 不做 eval、只看单次输出。

### 3.6 对协议的可落地设计（汇总）
1. **模板骨架**：Skill 式 `SKILL.md`——frontmatter 写 `name/description/适用条件`；正文含 3.1 八字段；附 `examples/`、`checklist.md` 按需加载。
2. **三道闸门**：计划闸门（先产出 SPEC/plan 再执行）、验收闸门（证据 + 可运行检查 + 独立复核）、交接闸门（阻塞/超预算/超轮次时升级并写清当前状态）。
3. **规则分层表**（硬→hook/CI，软→提示词，事实→上下文引用）作为协议必备附件。
4. **提示词 lint 清单**：矛盾检测、模糊词、缺输出契约、缺验收、缺停止条件、上下文冗余。
5. **迭代闭环**：失败案例→元提示（让模型只做最小增删改）→写入失败模式库→升级为规则；用留出任务集回归。
