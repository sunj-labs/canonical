---
name: ia-model
description: Build information architecture from entity inventory + task flows. Derives nav structure, labeling, and screen map from objects.
user_invocable: true
disable_model_invocation: false
---

# Information Architecture — Entity-Driven

Build the IA from entities and their relationships. For data-heavy operator tools,
the IA is entity-driven — screens derive from objects, not content hierarchies.

## When to Use

- After `/jtbd-tasks` and `/task-scenarios` — you have task flows and stories
- When navigation feels wrong or pages overlap in purpose
- When adding a new entity (new database model, new concept)
- When the user says "I don't know where to find X" or "these pages feel redundant"
- UX fitness review flags drift (new entities without UI surface, nav doesn't match)

## Method: Object-Oriented UX (OOUX)

### Step 1: Entity Inventory

List every object the system represents:

| Entity | Attributes | Relationships | UI Surface |
|--------|-----------|---------------|------------|
| ... | ... | ... | /path |

### Step 2: Entity Relationship Map

Draw the relationships (Mermaid ERD or graph).

### Step 3: Screen Derivation

**Each primary entity gets a list view and a detail view.** Secondary entities appear within their parent's views. This is the core OOUX principle.

| Entity | List View | Detail View | Appears In |
|--------|-----------|-------------|------------|
| ... | /path | /path/[id] | ... |

### Step 4: Navigation Structure

Derive nav from the screen map. Apply Peter Morville's IA framework:
- **Organization**: How are screens grouped?
- **Labeling**: What do we call each nav item? Match the user's mental model.
- **Navigation**: Primary nav (always visible) vs secondary (contextual).
- **Search**: When is filtering better than browsing?

### Step 5: Apply LATCH

5 ways to organize information — pick the right one per context:
- **L**ocation: geographic grouping
- **A**lphabet: alphabetical (rarely useful)
- **T**ime: chronological (recent first)
- **C**ategory: by type or classification
- **H**ierarchy: by importance or score

## Output Format

```markdown
## Entity Inventory
[table]

## Entity Map
[Mermaid diagram]

## Screen Map
[table: entity → list view, detail view, appears in]

## Navigation Structure
[primary nav, contextual nav, future nav]

## LATCH Analysis
[which organization scheme for which context]

## Gap Analysis
- Entities without UI surfaces
- Screens without clear entity ownership
- Nav items that don't map to entities or jobs
```

## Component Naming Convention

UI components should be **named after domain objects**, not generic UI concepts:
- `DealCard` not `Card`
- `ScorePills` not `BadgeGroup`
- `ThesisFilter` not `TabGroup`

## Next Step

Feeds into `/interaction-design` (state diagrams, sequence diagrams).

## References

- Sophia Prater, OOUX methodology (ooux.com)
- Peter Morville & Louis Rosenfeld, *Information Architecture for the World Wide Web*
- Abby Covert, *How to Make Sense of Any Mess*
