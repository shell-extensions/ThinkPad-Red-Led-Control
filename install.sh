#!/usr/bin/env bash
set -euo pipefail

HELPER_NAME="thinkpad-red-led-helper"
INSTALL_PATH="/usr/local/bin/${HELPER_NAME}"
SUDOERS_FILE="/etc/sudoers.d/thinkpad-red-led"
SERVICE_NAME="thinkpad-red-led-restore.service"
SERVICE_INSTALL_PATH="/etc/systemd/system/${SERVICE_NAME}"

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

candidates=(
  "${script_dir}/tools/${HELPER_NAME}"
  "${HOME}/.local/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev/tools/${HELPER_NAME}"
  "/usr/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev/tools/${HELPER_NAME}"
)

helper_src=""
for path in "${candidates[@]}"; do
  if [[ -f "${path}" ]]; then
    helper_src="${path}"
    break
  fi
done

if [[ -z "${helper_src}" ]]; then
  echo "Helper not found. Looked in:" >&2
  printf '  %s\n' "${candidates[@]}" >&2
  exit 1
fi

service_candidates=(
  "${script_dir}/tools/${SERVICE_NAME}"
  "${HOME}/.local/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev/tools/${SERVICE_NAME}"
  "/usr/share/gnome-shell/extensions/thinkpad-red-led@juanmagd.dev/tools/${SERVICE_NAME}"
)

service_src=""
for path in "${service_candidates[@]}"; do
  if [[ -f "${path}" ]]; then
    service_src="${path}"
    break
  fi
done

if [[ -z "${service_src}" ]]; then
  echo "Service file not found. Looked in:" >&2
  printf '  %s\n' "${service_candidates[@]}" >&2
  exit 1
fi

if ! command -v sudo >/dev/null 2>&1; then
  echo "sudo not found. Install sudo or run this as root." >&2
  exit 1
fi

target_user="${SUDO_USER:-${USER:-$(id -un)}}"
if [[ -z "${target_user}" ]]; then
  echo "Could not determine target user." >&2
  exit 1
fi

if [[ ! "${target_user}" =~ ^[a-z_][a-z0-9._-]*$ ]]; then
  echo "Refusing to write sudoers for unexpected username: ${target_user}" >&2
  exit 1
fi

echo "Installing helper from ${helper_src} to ${INSTALL_PATH}"
sudo install -o root -g root -m 0755 "${helper_src}" "${INSTALL_PATH}"

sudo tee "${SUDOERS_FILE}" >/dev/null <<EOF
${target_user} ALL=(root) NOPASSWD: ${INSTALL_PATH}
EOF

sudo chmod 0440 "${SUDOERS_FILE}"
sudo visudo -c -f "${SUDOERS_FILE}" >/dev/null

if command -v systemctl >/dev/null 2>&1; then
  echo "Installing systemd service from ${service_src} to ${SERVICE_INSTALL_PATH}"
  sudo install -o root -g root -m 0644 "${service_src}" "${SERVICE_INSTALL_PATH}"
  sudo systemctl daemon-reload
  sudo systemctl enable "${SERVICE_NAME}"
else
  echo "systemctl not found; skipping systemd service install." >&2
fi

echo "Done."
echo "Restart GNOME Shell or disable/enable the extension."
