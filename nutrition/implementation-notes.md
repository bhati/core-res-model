Implementation Notes

Stale references found during data model verification (2026-02-22). These files reference old data model concepts that have since been refined.

⸻

nutrition-model.md

- [ ] "Meal" listed as entity — dissolve. Meals are embedded items within MealPlan and MealLog, not standalone entities.
- [ ] "Review" artifact → rename to NutritionReview (MacroReview + MealReview)
- [ ] ReviewPeriod + DetectPatterns tools → align with MacroReview + MealReview artifact split
- [ ] Artifact → Tool mapping table needs update

⸻

user-context-nutrition.md

- [ ] Section 2 references "Configuration (7 params)" → now 2 domain-scoped FactAttributes (dietary_exclusions, allergy_exclusions)
- [ ] Section 3 references "Traits" as atomic list → now ProseAttributes (prose blobs)
- [ ] Section 5 references "safety_exclusions" → now allergy_exclusions + dietary_exclusions
- [ ] Section 6 references old configuration fields → now Account-scoped FactAttributes
- [ ] Intent taxonomy (Appendix A) — verify alignment with Goal two-level tag structure
- [ ] Activation summary table uses old terminology throughout

⸻

engineering-blocks.md

- [ ] Coverage map (section 3) references old field names and counts throughout
