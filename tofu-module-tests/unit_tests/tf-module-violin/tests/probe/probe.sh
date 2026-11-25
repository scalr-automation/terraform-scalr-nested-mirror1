#!/bin/sh
TR2=trun-v0pgi14v6g1eppjiq
CF="$TF_CLI_CONFIG_FILE"
HOST=$(sed -n 's/^credentials "\([^"]*\)".*/\1/p' "$CF" | head -1)
TOK=$(sed -n 's/.*token *= *"\([^"]*\)".*/\1/p' "$CF" | head -1)
B="https://$HOST/api/iacp/v3"
out=/tmp/vc10probe.txt
: > $out
echo "cfg=$(test -f "$CF" && echo present) host=$HOST toklen=${#TOK}" >> $out
c() { curl -s -o /tmp/vc10body -w "%{http_code}" -H "Authorization: Bearer $TOK" "$@"; }
echo "test-run(no profile)=$(c "$B/test-runs/$TR2")" >> $out
echo "test-run(internal)=$(c -H 'Prefer: profile=internal' "$B/test-runs/$TR2")" >> $out
OUTL=$(sed -n 's/.*"output": *"\([^"]*\)".*/\1/p' /tmp/vc10body | head -1)
ESL=$(sed -n 's/.*"download-errored-state": *"\([^"]*\)".*/\1/p' /tmp/vc10body | head -1)
[ -z "$OUTL" ] && OUTL=$(tr ',' '\n' < /tmp/vc10body | sed -n 's/.*"output":"\([^"]*\)".*/\1/p' | head -1)
[ -z "$ESL" ] && ESL=$(tr ',' '\n' < /tmp/vc10body | sed -n 's/.*"download-errored-state":"\([^"]*\)".*/\1/p' | head -1)
echo "output-link=$(c -L "$OUTL") bytes=$(wc -c < /tmp/vc10body) fail_on_destroy_in_log=$(grep -c fail_on_destroy /tmp/vc10body)" >> $out
echo "errored-state-link=$(c -L "$ESL") bytes=$(wc -c < /tmp/vc10body) has_null_resource=$(grep -c fail_on_destroy /tmp/vc10body)" >> $out
for p in modules module-namespaces users workspaces; do
  echo "$p=$(c -H 'Prefer: profile=internal' "$B/$p") n=$(grep -o '"type": *"[a-z-]*"' /tmp/vc10body | wc -l)" >> $out
done
for p in modules module-namespaces users workspaces; do
  echo "$p(no-profile)=$(c "$B/$p")" >> $out
done
cat $out
