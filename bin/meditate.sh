#!/usr/bin/env bash

set -euo pipefail

mindful_minutes="$HOME"/wiki/mindful-minutes.md

if [[ "${1:-}" == "total" ]]; then
  if [[ -f "$mindful_minutes" ]]; then
    cat "$mindful_minutes"
  else
    echo "No mindful minutes"
  fi

  exit 0
fi

if [[ "${1:-}" == "total-pretty" ]]; then
  if [[ -f "$mindful_minutes" ]]; then
    format="#[fg=colour0,bg=colour7] "
    # Set color
    if [[ "$(date -r "$mindful_minutes" +%D)" == "$(date +%D)" ]]; then
      format="#[fg=colour0,bg=colour3] "
    fi

    # Get total
    total="$(cat "$mindful_minutes")"

    # Years
    years_minutes="$(( 365 * 24 * 60 ))"
    years="$(( "$total" / "$years_minutes" ))"
    if [[ "$years" -gt 0 ]]; then
      format="${format} ${years} year"
      if [[ "$years" -ne 1 ]]; then
        format="${format}s, "
      else
        format="${format}, "
      fi
    fi
    total="$(( "$total" - "$(( "$years_minutes" * "$years" ))" ))"

    # Weeks
    weeks_minutes="$(( 7 * 24 * 60 ))"
    weeks="$(( "$total" / "$weeks_minutes" ))"
    if [[ "$weeks" -gt 0 ]]; then
      format="${format} ${weeks} week"
      if [[ "$weeks" -ne 1 ]]; then
        format="${format}s, "
      else
        format="${format}, "
      fi
    fi
    total="$(( "$total" - "$(( "$weeks_minutes" * "$weeks" ))" ))"

    # Days
    days_minutes="$(( 24 * 60 ))"
    days="$(( "$total" / "$days_minutes" ))"
    if [[ "$days" -gt 0 ]]; then
      format="${format} ${days} day"
      if [[ "$days" -ne 1 ]]; then
        format="${format}s, "
      else
        format="${format}, "
      fi
    fi
    total="$(( "$total" - "$(( "$days_minutes" * "$days" ))" ))"

    # Hours
    hours="$(( "$total" / 60 ))"
    if [[ "$hours" -gt 0 ]]; then
      format="${format}${hours} hour"
      if [[ "$hours" -ne 1 ]]; then
        format="${format}s, "
      else
        format="${format}, "
      fi
    fi
    total="$(( "$total" - "$(( "60" * "$hours" ))" ))"

    # Minutes
    format="${format}${total} minute"
    if [[ "$total" -ne 1 ]]; then
      format="${format}s"
    fi

    echo $format
  else
    echo "No mindful minutes"
  fi
  exit 0
fi

if [[ -z "${1:-}" ]]; then
  read -p "How long do you want to meditate for? " minutes
else
  minutes="${1:-}"
fi

echo "Meditating for $minutes minutes."

function partial {
  total="$(cat "$mindful_minutes")"
  completed_minutes="$(( "$second" / 60 ))"
  echo
  echo "Completed $completed_minutes minutes."
  echo "$(( "$completed_minutes" + "$total" ))" > "$mindful_minutes"
}

trap partial SIGINT

seconds="$(( 60 * "$minutes" ))"
for second in $(seq 1 "$seconds"); do
  sleep 1
done
total="$(cat "$mindful_minutes")"
total="$(( "$total" + "$minutes" ))"
echo "$total" > "$mindful_minutes"
terminal-notifier -message "Time up!" -sound "Submarine"

