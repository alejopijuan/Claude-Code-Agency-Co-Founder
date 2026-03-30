---
name: "{{name}}"
contact: "{{contact}}"
outreach_file: "{{outreach_file}}"
stage: "new-lead"
value: 0
created: "{{today}}"
last_updated: "{{today}}"
---

# {{name}} -- Pipeline Deal

## Deal Info
- **Contact:** {{contact}}
- **Estimated Value:** ${{value}}/mo
- **Use Case:** {{use_case}}

## Stage Transitions

| Date | From | To | Notes |
|------|------|----|-------|
| {{today}} | -- | {{stage}} | Created |
