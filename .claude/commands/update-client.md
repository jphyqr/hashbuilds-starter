# Update Client

Generate a client-friendly update message for WhatsApp or email.

## Instructions

1. Read /deliverables/PROGRESS.md to understand recent work
2. Read /deliverables/ROLLOUT.md to understand current phase status
3. Read /docs/PROJECT_ORIGIN.md to get client name and project name

## Generate Message

Create a friendly, non-technical update in this format:

```
Hey [Client Name]! Quick update on [Project Name]:

✅ COMPLETED:
- [Human-readable description of completed items]
- [Keep it simple, no jargon]

🚧 IN PROGRESS:
- [What you're currently working on]

📅 NEXT UP:
- [What's coming next]

You can track progress at: [production-url]/rollout

Questions? Just reply here!
```

## Rules

- Use simple language (no technical terms)
- Focus on outcomes, not implementation details
- Keep it brief (under 200 words)
- Be positive but honest
- Include the rollout page link

## After Generating

1. Save the message to /deliverables/CLIENT_UPDATE.txt
2. Tell the user the message is ready to copy
3. Remind them to review before sending

## Example Output

```
Hey Sarah! Quick update on Vancouver Sublets:

✅ COMPLETED:
- Login system is working - you can sign in with your email
- Admin dashboard is live - you can manage listings
- Mobile version looks great on phones

🚧 IN PROGRESS:
- Adding photo upload for listings

📅 NEXT UP:
- Search and filter for renters
- Contact form for inquiries

You can track progress at: vancouversublets.ca/rollout

Questions? Just reply here!
```
