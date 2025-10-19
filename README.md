# 🔥 Karen GitHub Action

<!-- karen-badge-start -->
<!-- karen-badge-end -->

Get brutally honest, AI-powered code reviews from Karen - no BS, just reality checks.

**Works with Anthropic Claude OR OpenAI GPT-4** - Choose your preferred AI provider.

## Features

- **Auto-Update README Badge** - Karen automatically keeps your score badge fresh
- **Brutally Honest Reviews** - AI-powered analysis that tells it like it is
- **Karen Score (0-100)** - Quantified assessment across 5 key dimensions
- **Auto PR Comments** - Karen roasts your PRs automatically
- **Auto-Commit Results** - Push scores, reviews, and badges back to your repo

## Quick Start

### 1. Add markers to your README (optional, but recommended)

```markdown
# My Project

<!-- karen-badge-start -->
<!-- karen-badge-end -->

Description...
```

### 2. Create `.github/workflows/karen.yml`

```yaml
name: Karen Code Review
on:
  push:
    branches: [main]

jobs:
  karen-review:
    runs-on: ubuntu-latest
    permissions:
      contents: write
      pull-requests: write

    steps:
      - uses: actions/checkout@v4

      - name: Karen Review
        uses: khaliqgant/karen-action@v1
        with:
          anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
          auto_update_readme: true  # Automatically update badge in README
          generate_badge: true
          post_comment: true

      - name: Commit results
        run: |
          git config user.name "github-actions[bot]"
          git config user.email "github-actions[bot]@users.noreply.github.com"
          git add .karen/ README.md
          git diff --staged --quiet || git commit -m "Update Karen review [skip ci]"
          git push
```

### 3. Add API Key

Get an API key and add it to your repository secrets:
- **Anthropic Claude (Recommended)**: [console.anthropic.com](https://console.anthropic.com/) → Add as `ANTHROPIC_API_KEY`
- **OpenAI GPT-4**: [platform.openai.com](https://platform.openai.com/) → Add as `OPENAI_API_KEY`

### 4. Get Roasted

Push code and Karen will:
- Analyze your repository
- Generate a score (0-100)
- Auto-update your README badge
- Comment on PRs
- Save detailed reviews to `.karen/review.md`

---

## Karen Score

Karen evaluates across 5 dimensions (0-20 points each):

| Dimension | What It Measures |
|-----------|------------------|
| 🎭 **Bullshit Factor** | Over-engineering vs. simplicity |
| ⚙️ **Actually Works** | Does it do what it claims? |
| 💎 **Code Quality** | Will the next dev curse you? |
| ✅ **Completion** | TODO vs. actually done |
| 🎯 **Practical Value** | Solves real problems vs. resume padding |

**Score Grades:**
- 90-100 🏆 Surprisingly legit
- 70-89 ✅ Actually decent
- 50-69 😐 Meh, it works I guess
- 30-49 🚨 Needs intervention
- 0-29 💀 Delete this and start over

## Configuration

| Input | Default | Description |
|-------|---------|-------------|
| `anthropic_api_key` | - | Anthropic API key for Claude |
| `openai_api_key` | - | OpenAI API key for GPT-4 |
| `auto_update_readme` | `false` | **Auto-insert/update badge in README** |
| `generate_badge` | `true` | Generate Karen score badge |
| `post_comment` | `true` | Post review as PR comment |
| `min_score` | `0` | Minimum score threshold (shows warning if below) |

### Optional: `.karen/config.yml`

```yaml
strictness: 8  # 1-10, how brutal Karen should be
weights:
  bullshitFactor: 0.25
  actuallyWorks: 0.25
  codeQualityReality: 0.20
  completionHonesty: 0.15
  practicalValue: 0.15
```

## Examples

### Minimal Setup
```yaml
- uses: khaliqgant/karen-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
```

### With Auto-Update Badge
```yaml
- uses: khaliqgant/karen-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    auto_update_readme: true  # Badge updates automatically!
```

### Enforce Minimum Score
```yaml
- uses: khaliqgant/karen-action@v1
  with:
    anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}
    min_score: 70  # Shows warning if score < 70
```

### Using OpenAI
```yaml
- uses: khaliqgant/karen-action@v1
  with:
    openai_api_key: ${{ secrets.OPENAI_API_KEY }}
```

## What Gets Created

```
.karen/
├── score.json              # Current score & breakdown
├── review.md               # Latest review
├── history/                # Historical reviews
│   └── 2025-10-18-12-30.md
└── badges/                 # Generated badges
    └── score-badge.svg
```

## 💡 Want Karen in Your IDE?

Get Karen interactively in Claude Code or Cursor with [PRPM](https://github.com/khaliqgant/prompt-package-manager):

```bash
npm install -g prmp
prmp install karen-skill    # Claude Code
prmp install karen-cursor-rule  # Cursor IDE
```

## FAQ

**Q: Will Karen roast my code?**
A: Yes. That's literally her job.

**Q: How does auto-update badge work?**
A: Karen finds `<!-- karen-badge-start -->` markers in your README (or adds them if missing) and updates the badge automatically.

**Q: Will this fail my CI?**
A: Only if you set `min_score` and Karen's score is below it.

**Q: How much does this cost?**
A: You need an Anthropic or OpenAI API key. Typical review costs ~$0.10-0.50 depending on repo size.

## License

MIT

---

*🔥 Get roasted. Get better. - Karen*
