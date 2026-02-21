HP04 — Core Challenges

⸻

1. What These Are

Two hard problems that sit at the boundary between the structured world (entities, memories, config) and the prose world (LLM conversation). Both are consequences of having LLM surfaces within a hard-surface architecture (HP01). Both sit at the edge of current technology limitations. No elegant solution exists — these will be mitigated iteratively.

⸻

2. Challenge A: Prose → Structure Handoff

When the user speaks in prose on an LLM surface, the system must extract structured data: entities, memories, configuration updates.

"I'm vegetarian, I avoid eggs, and I don't cook on weekdays" contains:
- Config update: dietary_type: vegetarian
- Memory (safety-critical): avoids eggs
- Memory (behavioral): doesn't cook on weekdays

The system must:
- Extract reliably from natural language
- Classify correctly (config vs memory vs allergen vs preference)
- Validate before writing to entity layer

Failure modes:
- Missed allergen → safety failure
- Misclassified config → corrupted planning
- Missed memory → lost personalization
- Hallucinated extraction → false data in ground truth

This occurs every time the LLM surface is active and the user responds with prose that contains structured intent.

⸻

3. Challenge B: Context Drift on LLM Surfaces

HP03 establishes that hard surfaces scope context deterministically. But when an LLM surface activates, conversation can escape the original scope.

User is on LogMeal → LLM surface activates → context loaded for meal logging.
User says: "Actually I've been stressed and overeating all week."

Now the LLM needs: circumstance awareness, empathy calibration, possibly eating disorder policy. None of which was in the injected context.

The hard surface scoped context correctly. The human drifted beyond it.

This is the cost of having an expert that can talk. A form can't drift. A conversation can.

⸻

4. Why These Are Core, Not Solvable

Both problems sit at the structured ↔ unstructured boundary that defines this architecture. The system is entity/memory-first (structured) but uses LLM for skill (unstructured). The boundary between these worlds is where reliability is hardest.

Technology will improve (better extraction, better context management), but the fundamental tension — structured ground truth produced through unstructured interaction — is inherent to the architecture.

⸻

5. Mitigation Strategies (To Be Developed)

Prose → Structure:
- TBD: extraction validation, confirmation flows, confidence thresholds, human-in-the-loop for safety-critical writes

Context Drift:
- TBD: re-scoping mid-conversation, escalation to broader context tier, bounded LLM-surface conversations, graceful handoff to appropriate surface
