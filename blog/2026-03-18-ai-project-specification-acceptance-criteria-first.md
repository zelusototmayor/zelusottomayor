---
title: "Why AI Projects Fail Without Acceptance Criteria (And How to Write Them)"
slug: ai-project-specification-acceptance-criteria-first
date: 2026-03-18
author: "Ze Lu Sottomayor"
meta_description: "Most AI automation projects fail not because the AI is wrong but because the spec was vague. Acceptance Criteria First (ACF) is the discipline that changes the outcome."
tags: ["AI project management", "AI automation", "acceptance criteria", "AI consulting", "workflow automation", "AI specification", "AI project planning"]
published: true
---

The single most common reason AI automation projects fail isn't the technology. It's the brief.

A client describes what they want. The consultant — or the client themselves, prompting Claude Code directly — starts building. Three weeks in, something is technically working but wrong in ways nobody can articulate. The system does what was asked, not what was needed. There's a gap between "what we said" and "what we meant," and closing it costs more than the original build.

This pattern has a name now. Practitioners call it the spec gap. And in 2026, as more businesses are building AI automation tools themselves or with help, it's the single most expensive problem in AI project delivery.

There's a fix. It's not complicated. It's just discipline: Acceptance Criteria First.

## What Acceptance Criteria First Actually Means

Acceptance Criteria First (ACF) is a simple discipline: before any AI agent writes a line of code or any automation is built, you write down exactly what "done" looks like in plain English.

Not "build a lead qualification bot." That's a goal.

Done looks like this:

- When a lead submits the web form, an automated email is sent within 2 minutes
- The email uses the lead's first name and company name from the form fields
- If the company name field is empty, the email omits it entirely (no "[company]" placeholder)
- The email includes a single calendar link (Calendly) and nothing else
- A Slack message is sent to the #sales channel containing the lead's name, email, and form submission time
- If the email fails to send, the Slack message still goes through and includes the word "EMAIL FAILED"

That's acceptance criteria. It's specific enough that any competent developer — or AI agent — can build to it. It's also specific enough that you can check whether the build actually matches what you asked for.

The discipline is in writing this *before* you build, not after.

## Why Most AI Projects Skip This Step

There are three reasons teams skip acceptance criteria:

**Speed.** Writing a clear spec feels slower than starting. Especially when everyone understands (at a vague level) what the goal is. The brief seems obvious. Why write it down?

**Uncertainty.** The client doesn't know exactly what they want yet. They're building to figure it out. Asking them to write acceptance criteria feels like asking for precision they don't have.

**Delegation trust.** The developer or consultant is good. They'll figure it out. Micromanaging the spec feels like it undermines the relationship.

All three reasons are wrong, and here's why.

Speed: writing acceptance criteria takes 30 to 90 minutes per feature. Rebuilding a feature because the spec was vague takes 4 to 20 hours. The math is simple. You don't save time by skipping the spec.

Uncertainty: you don't need to know exactly what you want to write acceptance criteria. You need to know what the output should look like and how you'd verify it works. "I'll know it when I see it" is not acceptable because "see it" is a 3-week build away.

Delegation trust: good consultants and developers want clear specs. Vague specs are the leading cause of scope creep, client frustration, and project restarts. A clear spec isn't micromanagement — it's respect for the person building and the client paying.

## The Compounding Cost of Skipping the Spec

Here's the hidden cost most people don't account for: review latency.

Avery Pennarun (founder of Tailscale) quantified the review cost structure for software projects in work that circulated widely this year. Every layer of review adds 10x to the timeline. A question without a clear answer that requires a meeting adds a week. A deliverable that needs stakeholder sign-off takes a month.

The acceptance criteria discipline exists to compress that review latency. When you've pre-agreed on what success looks like, review becomes a check against criteria, not a judgment call. "Does this do X?" is faster than "Is this good?"

For AI automation projects specifically, the gap between "technically functional" and "actually correct" is unusually wide. AI systems that do exactly what was specified but produce the wrong business output are common. The only reliable way to close that gap is to specify the right output in advance — before the build begins.

## How to Write Acceptance Criteria for AI Automation Projects

The format that works best is simple: given/when/then or just a numbered list of verifiable states.

For each feature or workflow, write:

1. What triggers this workflow
2. What inputs are required
3. What outputs must be produced (exactly — including format, timing, and edge cases)
4. What errors must be handled and how
5. What "done" looks like when a human tests it

You don't need special software. A Google Doc, a Notion page, or a markdown file works. The goal is a document both parties review and agree on before the first line of code is written.

Here's an example for a simple AI-powered invoice processing workflow:

**Trigger:** A PDF is uploaded to the /invoices folder in Google Drive.

**Processing requirements:**
- Extract vendor name, invoice date, invoice number, line items, and total amount
- If any field cannot be extracted with confidence above 80%, mark the invoice as "NEEDS REVIEW"
- Invoices under €500 with no "NEEDS REVIEW" flag are automatically approved
- Invoices over €500 or flagged for review are added to the Airtable "Pending Approval" view

**Output format:**
- Airtable row with: Vendor, Date, Invoice Number, Total, Status (Auto-approved / Pending Review), PDF link
- Slack notification in #finance when any invoice is added

**Error handling:**
- If the PDF is password-protected, move it to /invoices/errors and send a Slack DM to the finance manager

**Test case:** Upload a sample invoice from an existing vendor. Verify the Airtable row populates within 3 minutes. Verify the Slack notification fires. Verify a password-protected PDF triggers the error path.

That's a specification. It can be handed to any developer, any AI agent, or any automation platform and built with minimal back-and-forth. When it's done, it can be tested in 10 minutes.

## What to Do When the Client Doesn't Know What They Want

This is the real challenge in AI consulting. Clients often arrive with a problem, not a specification. They know the pain. They don't know the solution.

The consultant's job is to convert "I want to automate my client onboarding" into a set of acceptance criteria before any building begins.

The fastest way to do this is a structured requirements session with three questions:

1. **Walk me through the current process step by step.** Not the ideal process — the actual one. Who does what, when, using what tools.
2. **What happens when this goes wrong?** Edge cases reveal requirements that the happy path obscures.
3. **How will you know this is working six months from now?** This forces the client to articulate a measurable outcome, which becomes the acceptance criteria.

Run this session, take notes, and write a draft acceptance criteria document. Send it to the client before any building starts. The document will have errors. That's fine. The errors you fix before building are free. The errors you find after building cost money.

## ACF and AI Coding Agents: Why It Matters Even More Now

The discipline matters more, not less, as AI coding agents become more capable.

An AI coding agent running on a vague spec is not a productivity tool. It's an amplified source of confident-sounding wrong work. Claude Code, Codex, and similar tools will build exactly what they're asked to build — quickly, thoroughly, and without hesitation — even when what they're asked to build is wrong.

The METR study from earlier this year quantified the gap: AI-generated code that passes benchmarks is accepted by real maintainers at rates that haven't improved in over a year. The problem isn't capability. It's specification. The AI builds to the spec it receives. If the spec is vague, the output is confidently vague.

Acceptance criteria are the mechanism that makes AI coding agents reliable. They convert "the AI will figure it out" into "the AI will check its output against pre-agreed criteria." The second is systematically faster and produces better results.

This is why the best AI automation shops have shifted their workflow: spec first, build second. The spec is the deliverable. The code is the proof.

## Acceptance Criteria as a Client Deliverable

One underused application: give the acceptance criteria document to the client before billing for the build.

This does several things:

- It demonstrates rigor and process maturity
- It creates a clear scope boundary (anything not in this document is a change request)
- It shifts the approval step to the beginning of the project, where it's cheap, rather than the end, where it's expensive
- It protects both parties from the "I thought it would include X" conversation

Clients who see a well-structured acceptance criteria document before the build begins are more confident in the consultant and more likely to approve the project without prolonged negotiation. It's a sales and delivery tool simultaneously.

## FAQ: AI Project Acceptance Criteria

**How long should acceptance criteria be for a typical AI automation project?**

For a single workflow (e.g., lead qualification, invoice processing, appointment booking), expect 1–3 pages. For a multi-workflow system, 5–10 pages. Longer documents suggest the scope is too large or the requirements aren't yet clear enough to build.

**What's the difference between acceptance criteria and a functional spec?**

Acceptance criteria describe what "done" looks like from the outside — testable, observable outcomes. A functional spec describes how the system works internally. You need acceptance criteria before you build. You may or may not need a functional spec, depending on project complexity.

**How do I handle requirements that change mid-project?**

Change requests are additions to or modifications of the acceptance criteria document. Document the change, agree on timeline and cost implications, and update the document before implementing. Projects without this discipline grow uncontrolled.

**Can acceptance criteria be written for AI systems that learn or adapt?**

Yes, but they focus on observable behavior rather than internal state. "The system correctly classifies at least 90% of test cases in the provided dataset" is a valid acceptance criterion for an AI classification system. "The model converges" is not — it's not verifiable by the client.

**What if the client rejects the acceptance criteria process?**

This is a signal, not a problem. Clients who refuse to pre-agree on what success looks like are often unprepared for the project. The consultants who insist on this process protect themselves from endless scope creep. It's reasonable to make it a non-negotiable part of your engagement process.

---

**Related reading:**

- [Why AI Automation Projects Fail](/blog/why-ai-automation-projects-fail)
- [What Does an AI Consultant Actually Deliver?](/blog/what-does-an-ai-consultant-actually-deliver)
- [Stop Sloppypasta: Why AI Consulting Is Failing Clients](/blog/stop-sloppypasta-ai-consulting-deliverables)
- [How to Measure the ROI of AI Automation](/blog/how-to-measure-roi-of-ai-automation)

---

**Building AI automation that actually works?** The difference between a successful project and a painful rebuild is usually in the specification. If you want a structured process for defining requirements, scoping builds, and delivering AI automation that does what was asked — [let's talk](https://zelusottomayor.com/contact).
