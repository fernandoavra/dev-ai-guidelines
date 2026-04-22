#!/usr/bin/env bash
# Claude Code status line — matches image layout

input=$(cat)

# ── Colors ────────────────────────────────────────────────────────────────────
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

# ── Parse JSON ────────────────────────────────────────────────────────────────
model_name=$(echo "$input" | jq -r '.model.display_name // .model.id // "Claude"')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // 200000')
input_tokens=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // 0')
output_tokens=$(echo "$input" | jq -r '.context_window.current_usage.output_tokens // 0')
cache_read=$(echo "$input" | jq -r '.context_window.current_usage.cache_read_input_tokens // 0')
cache_write=$(echo "$input" | jq -r '.context_window.current_usage.cache_creation_input_tokens // 0')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // 100')
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
cwd=$(echo "$input" | jq -r '.cwd // .workspace.current_dir // "."')

# ── Format helpers ─────────────────────────────────────────────────────────────
format_k() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf "%.1fm" "$(echo "scale=1; $n / 1000000" | bc)"
  elif [ "$n" -ge 1000 ]; then
    printf "%.1fk" "$(echo "scale=1; $n / 1000" | bc)"
  else
    printf "%d" "$n"
  fi
}

# Round to nearest 0.1k / 0.1m
fmt_tokens() {
  local n=$1
  if [ "$n" -ge 1000000 ]; then
    printf "%.1fm" "$(echo "scale=4; $n / 1000000" | bc 2>/dev/null || echo '0')"
  elif [ "$n" -ge 1000 ]; then
    printf "%.1fk" "$(echo "scale=4; $n / 1000" | bc 2>/dev/null || echo '0')"
  else
    printf "%d" "$n"
  fi
}

# ── Dot meter (10 dots) ────────────────────────────────────────────────────────
# filled dot: ●  empty dot: ○
dot_meter() {
  local pct=${1:-0}
  local filled=$(echo "$pct * 10 / 100" | bc 2>/dev/null || echo "0")
  [ "$filled" -gt 10 ] && filled=10
  local empty=$((10 - filled))
  local meter=""
  for ((i=0; i<filled; i++)); do meter="${meter}●"; done
  for ((i=0; i<empty; i++)); do meter="${meter}○"; done
  printf "%s" "$meter"
}

# ── Context window values ──────────────────────────────────────────────────────
# Total used tokens = input (which already includes cache in Claude's accounting)
total_used=$(echo "$input_tokens + $output_tokens" | bc 2>/dev/null || echo "0")
# If used_pct is available use it to back-calc tokens for consistency
if [ -n "$used_pct" ] && [ "$used_pct" != "0" ] && [ "$used_pct" != "null" ]; then
  : # use existing total_used
fi

# Remaining tokens
remaining_tokens=$(( ctx_size - total_used ))
[ "$remaining_tokens" -lt 0 ] && remaining_tokens=0

used_pct_int=$(printf "%.0f" "$used_pct" 2>/dev/null || echo "0")
remaining_pct_int=$(printf "%.0f" "$remaining_pct" 2>/dev/null || echo "100")

ctx_fmt=$(fmt_tokens "$ctx_size")
used_fmt=$(fmt_tokens "$total_used")
remaining_fmt=$(fmt_tokens "$remaining_tokens")

# ── Model display name: strip "Claude " prefix for brevity ────────────────────
model_short=$(echo "$model_name" | sed 's/^Claude //')

# ── LINE 1: Model | token usage | free tokens ─────────────────────────────────
line1=$(printf "${CYAN}%s (%s context)${RESET} | ${CYAN}%s / %s (%d%% used)${RESET} | ${CYAN}%s %d%% free${RESET}" \
  "$model_short" "$ctx_fmt" \
  "$used_fmt" "$ctx_fmt" "$used_pct_int" \
  "$remaining_fmt" "$remaining_pct_int")

# ── Git branch ────────────────────────────────────────────────────────────────
git_branch=""
if command -v git >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null || \
               git rev-parse --abbrev-ref HEAD 2>/dev/null || true)
fi

# ── Active task (from session registry) ───────────────────────────────────────
active_task=""
sessions_file="$cwd/.claude/plans/.active-sessions.json"
if [ -f "$sessions_file" ]; then
  active_task=$(jq -r --arg pid "$PPID" '.[$pid].task // empty' "$sessions_file" 2>/dev/null || true)
fi

# ── Branch + task suffix ──────────────────────────────────────────────────────
branch_task=""
if [ -n "$git_branch" ] && [ -n "$active_task" ]; then
  branch_task=$(printf "  ${YELLOW}%s${RESET} | ${GREEN}▶ %s${RESET}" "$git_branch" "$active_task")
elif [ -n "$git_branch" ]; then
  branch_task=$(printf "  ${YELLOW}%s${RESET}" "$git_branch")
elif [ -n "$active_task" ]; then
  branch_task=$(printf "  ${GREEN}▶ %s${RESET}" "$active_task")
fi

# ── LINE 2: current rate limit meter | weekly meter | git branch | task ──────
line2=""
if [ -n "$five_hour_pct" ]; then
  fh_pct_int=$(printf "%.0f" "$five_hour_pct")
  fh_meter=$(dot_meter "$fh_pct_int")
  if [ -n "$seven_day_pct" ]; then
    sd_pct_int=$(printf "%.0f" "$seven_day_pct")
    sd_meter=$(dot_meter "$sd_pct_int")
    line2=$(printf "${CYAN}current: ${GREEN}%s %d%%${RESET} | ${CYAN}weekly: ${GREEN}%s %d%%${RESET}%b" \
      "$fh_meter" "$fh_pct_int" \
      "$sd_meter" "$sd_pct_int" \
      "${branch_task:+ |$branch_task}")
  else
    line2=$(printf "${CYAN}current: ${GREEN}%s %d%%${RESET}%b" \
      "$fh_meter" "$fh_pct_int" \
      "${branch_task:+ |$branch_task}")
  fi
elif [ -n "$branch_task" ]; then
  line2=$(printf "%b" "$branch_task")
fi

# ── Time helpers ──────────────────────────────────────────────────────────────
fmt_reset_time() {
  local epoch=$1
  local now
  now=$(date +%s)
  local diff=$(( epoch - now ))
  [ "$diff" -lt 0 ] && diff=0

  # Format time: h:mmAM/PM
  local reset_time
  reset_time=$(date -r "$epoch" +"%l:%M%p" 2>/dev/null || date -d "@$epoch" +"%l:%M%p" 2>/dev/null || "")
  reset_time=$(echo "$reset_time" | tr '[:upper:]' '[:lower:]' | sed 's/ //')

  # Time remaining
  local hrs=$(( diff / 3600 ))
  local mins=$(( (diff % 3600) / 60 ))
  local remaining_str=""
  if [ "$hrs" -gt 0 ]; then
    remaining_str="${hrs}h${mins}m"
  else
    remaining_str="${mins}m"
  fi

  printf "%s (%s)" "$reset_time" "$remaining_str"
}

fmt_weekly_reset() {
  local epoch=$1
  local day_time
  day_time=$(date -r "$epoch" +"%a, %l:%M%p" 2>/dev/null || date -d "@$epoch" +"%a, %l:%M%p" 2>/dev/null || "")
  # lowercase am/pm, trim spaces
  day_time=$(echo "$day_time" | sed 's/AM/am/g; s/PM/pm/g' | sed 's/  */ /g' | sed 's/ ,/,/g')
  printf "%s" "$day_time"
}

# ── LINE 3: reset times ───────────────────────────────────────────────────────
line3=""
if [ -n "$five_hour_resets" ] || [ -n "$seven_day_resets" ]; then
  parts=""
  if [ -n "$five_hour_resets" ]; then
    fh_time=$(fmt_reset_time "$five_hour_resets")
    parts="${CYAN}resets ${fh_time}${RESET}"
  fi
  if [ -n "$seven_day_resets" ]; then
    sd_time=$(fmt_weekly_reset "$seven_day_resets")
    if [ -n "$parts" ]; then
      parts="${parts} | ${CYAN}resets ${sd_time}${RESET}"
    else
      parts="${CYAN}resets ${sd_time}${RESET}"
    fi
  fi
  line3=$(printf "%b" "$parts")
fi

# ── LINE 4: auto mode indicator ───────────────────────────────────────────────
default_mode=$(echo "$input" | jq -r '.permissions.defaultMode // empty' 2>/dev/null || true)
# We read it from the settings file as a fallback
if [ -z "$default_mode" ]; then
  settings_file="$HOME/.claude/settings.json"
  if [ -f "$settings_file" ]; then
    default_mode=$(jq -r '.permissions.defaultMode // empty' "$settings_file" 2>/dev/null || true)
  fi
fi

line4=""
if [ "$default_mode" = "auto" ]; then
  line4=$(printf "${YELLOW}►► auto mode on${RESET} (shift+tab to cycle)")
elif [ "$default_mode" = "bypassPermissions" ]; then
  line4=$(printf "${YELLOW}►► bypass mode${RESET} (shift+tab to cycle)")
elif [ -n "$default_mode" ]; then
  line4=$(printf "${YELLOW}►► %s mode${RESET} (shift+tab to cycle)" "$default_mode")
fi

# ── Output ────────────────────────────────────────────────────────────────────
output=""
[ -n "$line1" ] && output="${line1}"
[ -n "$line2" ] && output="${output}\n${line2}"
[ -n "$line3" ] && output="${output}\n${line3}"
[ -n "$line4" ] && output="${output}\n${line4}"

printf "%b\n" "$output"
