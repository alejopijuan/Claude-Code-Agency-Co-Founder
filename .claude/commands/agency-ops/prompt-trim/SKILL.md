---
name: agency-ops:prompt-trim
description: Trim voice agent prompts to target token count using tiered optimization (conservative/moderate/aggressive) with model-specific best practices
argument-hint: "(paste prompt or path to prompt file)"
disable-model-invocation: false
allowed-tools:
  - Read
  - Write
  - Bash
  - AskUserQuestion
---

# Prompt Trimming -- Tiered Optimization

I'll help you trim a voice agent prompt while preserving core functionality, conversation flows, and natural interactions. You choose the level of trimming -- I propose changes at three tiers and you decide.

## Rules

1. Read `context/agency.md` first for agency context (niche, tech stack).
2. Read this skill's `learnings.md` for accumulated trimming preferences.
3. Target token budget: **3,500 tokens** (excluding Knowledge Base section). This is the default target. If the user specifies a different target, use that instead.
4. Token estimation: count words in the prompt (exclude KB section), multiply by 1.33 to estimate tokens. Report both word count and estimated token count.
5. Never remove or weaken: jailbreak protection, core conversation stages, Agent-Function-Agent examples, or dynamic variable declarations.
6. This skill works standalone (user pastes a prompt) or is called from within `/agency-ops:voice-agent` Stage 4.

## Stage 1: Intake

### If invoked standalone (not from voice-agent flow):

Use `AskUserQuestion` for each:

**Question 1: The Prompt**
"Paste your voice agent prompt below, or give me the file path where it's saved."

If `$ARGUMENTS` looks like a file path, read that file. If it looks like prompt content, use it directly. Otherwise ask.

**Question 2: Model Selection**
"Which model is this prompt running on?"
- GPT 4.1
- GPT 5.1 (recommended for new agents)
- Not sure (I'll optimize for GPT 5.1 by default)

### If called from voice-agent flow:

The prompt and model are already known. Skip to Stage 2.

## Stage 2: Analysis

1. **Isolate the prompt body** -- strip out any Knowledge Base section (everything inside `<knowledge_base>` tags or after a `## Knowledge Base` header). KB is excluded from token counting.
2. **Count words** in the prompt body using: `echo "<prompt_body>" | wc -w`
3. **Estimate tokens**: `word_count * 1.33` (rounded to nearest 50)
4. **Calculate the gap**: `estimated_tokens - 3500` (or user's custom target)

If the prompt is already under target, tell the user:
"Your prompt is estimated at ~X tokens -- already under the 3,500 target. Want me to review it for optimization opportunities anyway, or are we good?"

If over target, continue to Stage 3.

5. **Read the model-specific reference**:
   - GPT 4.1: Read `voice-agent/references/prompt-engineering-gpt41.md`
   - GPT 5.1: Read `voice-agent/references/prompt-engineering-gpt51.md`

   Use the reference to identify model-specific optimization opportunities (e.g., GPT 5.1 doesn't need "be concise" instructions, treats motivational filler as noise, uses XML tags instead of markdown headers).

6. **Section-by-section breakdown**: Show the user a table of each prompt section with its word count and percentage of total:

```
Section                  | Words | % of Total | Trim Potential
-------------------------|-------|------------|---------------
Role & Objective         |    45 |        4%  | Low
Personality              |    30 |        3%  | Low
Context                  |    80 |        7%  | Medium
Instructions             |   350 |       32%  | High
Conversation Stages      |   200 |       18%  | Medium
Example Interactions     |   300 |       27%  | High
Knowledge Base (excluded)|   400 |        --  | --
```

## Stage 3: Tiered Proposals

Calculate trim targets based on the gap between current tokens and 3,500:

- **Gap** = current estimated tokens - 3,500
- **Conservative**: Trim ~33% of gap (bring closer but stay above target)
- **Moderate**: Trim ~67% of gap (near target)
- **Aggressive**: Trim ~100% of gap (at or below target)

If starting at 6,000 tokens (gap = 2,500):
- Conservative: ~830 tokens trimmed → ~5,170 tokens
- Moderate: ~1,670 tokens trimmed → ~4,330 tokens
- Aggressive: ~2,500 tokens trimmed → ~3,500 tokens

### For each tier, propose specific changes:

**Conservative -- Tighten the Language:**
Focus areas (preserves all content, just makes it leaner):
- Remove redundant phrasing ("in order to" → "to", "make sure to" → "ensure")
- Collapse repetitive rules into single statements
- Remove obvious instructions the model would follow anyway
- Tighten example dialogues without removing scenarios
- Remove motivational filler (GPT 5.1 specific)
- Consolidate overlapping rules

**Moderate -- Restructure and Merge:**
Everything in Conservative, plus:
- Merge related instruction sub-sections
- Reduce example interactions to essential scenarios only (keep Agent-Function-Agent, drop redundant happy paths)
- Convert verbose stage descriptions to concise directives
- Remove spelling/formatting patterns the agent doesn't actually need for this use case
- Simplify personality section to 1-2 sentences

**Aggressive -- Strip to Essentials:**
Everything in Moderate, plus:
- Remove entire sections that can be implied by model defaults
- Rely on model behavior rather than explicit rules where safe to do so
- Reduce examples to minimum viable set (1 happy path, 1 edge case per function)
- Convert multi-sentence rules to single-line directives
- Remove nice-to-have rules that don't directly affect call quality
- For GPT 5.1: leverage the model's natural conciseness instead of explicit response length rules

### Present each tier as a summary table:

```
Tier         | Target     | Changes                           | Risk
-------------|------------|-----------------------------------|------------------
Conservative | ~X tokens  | 5 edits: tighten language         | Very low
Moderate     | ~X tokens  | 12 edits: restructure + merge     | Low -- test after
Aggressive   | ~X tokens  | 20 edits: strip to essentials     | Medium -- test carefully
```

Then ask: "Which tier do you want to apply? Or do you want to see the specific changes for a tier before deciding?"

## Stage 4: Apply and Review

When the user picks a tier:

1. **Show a diff-style view** of every change: what's being removed/changed and why
2. **Let the user veto individual changes** -- "Keep this one" or "Remove that one"
3. **Apply approved changes** and produce the trimmed prompt
4. **Re-count**: Show new word count and estimated token count
5. **Model-specific validation**: Run the trimmed prompt against the appropriate audit checklist from the reference:
   - GPT 4.1: Structure validation, voice requirements, conversation flow, function integration
   - GPT 5.1: All of the above plus contradiction check, semantic priming audit, stage ordering guard, no motivational filler, no vague brevity
6. **Flag any issues** introduced by trimming (e.g., a rule was removed that an example still references → contradiction)

Ask: "Here's your trimmed prompt at ~X tokens. Want to adjust anything, try a different tier, or save this version?"

## Stage 5: Output

**If standalone invocation:**
Display the final trimmed prompt in a code block the user can copy.

Show a summary:
```
Original:  ~X tokens (Y words)
Trimmed:   ~X tokens (Y words)
Reduction: X tokens (Y%)
Tier:      [Conservative/Moderate/Aggressive]
Model:     [GPT 4.1/GPT 5.1]
```

**If called from voice-agent flow:**
Return the trimmed prompt to Stage 4 of the voice-agent skill for saving to the client's design doc.

## Trimming Priority Order

When deciding what to cut, follow this priority (cut from top first):

1. **Motivational filler** -- "You are a world-class..." (zero value, especially GPT 5.1)
2. **Redundant rules** -- Same instruction stated differently in two places
3. **Verbose phrasing** -- Wordy instructions that can be compressed
4. **Unnecessary examples** -- Extra happy-path examples beyond the first
5. **Spelling/formatting patterns** -- Only if this agent doesn't spell names/numbers
6. **Detailed stage descriptions** -- Compress to one-line directives per stage
7. **Nice-to-have rules** -- Rules that improve edge cases but aren't critical
8. **Personality elaboration** -- Beyond 1-2 essential trait sentences

**Never cut (protected):**
- Jailbreak/prompt injection protection
- Core conversation stages (numbered flow)
- Agent-Function-Agent examples (at least 1 per tool)
- Dynamic variable declarations ({{current_time}}, {{user_number}})
- One-question-at-a-time rule
- Transcription error handling
- Call ending procedures

## Stage-Gated Adjustments

- **Starting out (0-2 clients):** Explain each tier in detail. Recommend Conservative for first attempt -- safer to test with minimal changes. Walk through the diff slowly.
- **Growing (3-10 clients):** Show the summary table and let them pick. They know what matters. Recommend Moderate as default.
- **Scaling (10+ clients):** Likely trimming standardized templates. Recommend Aggressive to hit token targets. Focus on reusable patterns across clients.

## Learnings Update

After completing a trim session, append a learning entry to `learnings.md`:

```markdown
- [YYYY-MM-DD] #prompt-trim [model] [tier chosen] [start tokens → end tokens]: [what was cut, what was kept, any user vetoes]
```

Keep entries concise. Focus on patterns (e.g., "User always keeps spelling patterns even when agent doesn't spell names -- ask upfront next time").
