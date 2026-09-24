# Planovar Client (Flutter) — build & run with dev / staging / prod flavors.
#
# Environment config lives in config/<env>.json and is injected with
# --dart-define-from-file. Release builds auto-bump the build number (+N) in
# pubspec.yaml (override the version name with VERSION=1.2.0). iOS flavor builds
# require the one-time Xcode scheme/config setup — see FLAVORS.md.
.PHONY: help get \
        web build-web android-local ios-local \
        run-dev run-staging run-prod \
        apk-dev apk-staging apk-prod \
        aab-dev aab-staging aab-prod \
        ipa-dev ipa-staging ipa-prod

FLUTTER ?= flutter
WEB_PORT ?= 3001
DEVICE ?=
VERSION ?=
# Local API for on-device dev loops (Android emulator reaches the host at 10.0.2.2).
LOCAL_API_URL ?= http://localhost:3000
ANDROID_LOCAL_API_URL ?= http://10.0.2.2:3000
CYAN  := \033[0;36m
RESET := \033[0m
DEVICE_FLAG = $(if $(DEVICE),-d "$(DEVICE)",)

help: ## Show this help
	@echo ""
	@echo "  Planovar Client — commands"
	@echo ""
	@echo "  $(CYAN)Local dev (localhost API):$(RESET)"
	@echo "    make web                 Run in browser on port $(WEB_PORT)"
	@echo "    make android-local       Run dev flavor on Android (API via 10.0.2.2)"
	@echo "    make ios-local           Run dev flavor on iOS Simulator"
	@echo ""
	@echo "  $(CYAN)Run a flavor (uses config/<env>.json server):$(RESET)"
	@echo "    make run-dev | run-staging | run-prod   [DEVICE=<id>]"
	@echo ""
	@echo "  $(CYAN)Release builds (auto-bumps build number; VERSION=1.2.0 to set name):$(RESET)"
	@echo "    make aab-dev | aab-staging | aab-prod   Android App Bundle (.aab)"
	@echo "    make apk-dev | apk-staging | apk-prod   Android APK"
	@echo "    make ipa-dev | ipa-staging | ipa-prod   iOS IPA (needs Xcode setup)"
	@echo "    make build-web                          Web (prod config)"
	@echo ""

get: ## Install Flutter dependencies
	$(FLUTTER) pub get

# ── Local development (points at a locally-running API) ───────────────────────
web:
	$(FLUTTER) run -d web-server --web-port $(WEB_PORT) \
		--dart-define-from-file=config/dev.json --dart-define=API_BASE_URL=$(LOCAL_API_URL)

android-local:
	$(FLUTTER) run --flavor dev $(DEVICE_FLAG) \
		--dart-define-from-file=config/dev.json --dart-define=API_BASE_URL=$(ANDROID_LOCAL_API_URL)

ios-local:
	$(FLUTTER) run --flavor dev $(DEVICE_FLAG) \
		--dart-define-from-file=config/dev.json --dart-define=API_BASE_URL=$(LOCAL_API_URL)

# ── Run a flavor against its configured server ────────────────────────────────
run-dev run-staging run-prod: run-%:
	$(FLUTTER) run --flavor $* --dart-define-from-file=config/$*.json $(DEVICE_FLAG)

# ── Release builds (bump build number first) ──────────────────────────────────
apk-dev apk-staging apk-prod: apk-%:
	@v=$$(./tool/bump_build.sh $(VERSION)); printf "$(CYAN)APK %s [%s]$(RESET)\n" "$$v" "$*"; \
	$(FLUTTER) build apk --release --flavor $* --dart-define-from-file=config/$*.json

aab-dev aab-staging aab-prod: aab-%:
	@v=$$(./tool/bump_build.sh $(VERSION)); printf "$(CYAN)AAB %s [%s]$(RESET)\n" "$$v" "$*"; \
	$(FLUTTER) build appbundle --release --flavor $* --dart-define-from-file=config/$*.json

ipa-dev ipa-staging ipa-prod: ipa-%:
	@v=$$(./tool/bump_build.sh $(VERSION)); printf "$(CYAN)IPA %s [%s]$(RESET)\n" "$$v" "$*"; \
	$(FLUTTER) build ipa --release --flavor $* --dart-define-from-file=config/$*.json

build-web: ## Build web (prod config)
	$(FLUTTER) build web --release --dart-define-from-file=config/prod.json
