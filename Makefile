# Planovar Client (Flutter) — self-contained Makefile (deployable independently).
.PHONY: help get web android ios all build-web build-apk build-ios

WEB_PORT ?= 3001
API_BASE_URL ?= http://localhost:3000
# Optional device override, e.g. `make ios DEVICE="iPhone Air"` or a simulator UDID.
DEVICE ?=
# Android emulator can't see the host's "localhost" — it reaches the host at 10.0.2.2.
ANDROID_API_BASE_URL ?= http://10.0.2.2:3000
CYAN  := \033[0;36m
RESET := \033[0m

help: ## Show this help
	@echo ""
	@echo "  Planovar Client app – commands (web port $(WEB_PORT))"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?## "}; {printf "  $(CYAN)%-12s$(RESET) %s\n", $$1, $$2}'
	@echo ""

get: ## Install Flutter dependencies
	flutter pub get

web: ## Run in the browser (port $(WEB_PORT))
	flutter run -d web-server --web-port $(WEB_PORT) --dart-define=API_BASE_URL=$(API_BASE_URL)

android: ## Run on Android (host API reached via 10.0.2.2; DEVICE=<id> to pick a device)
	flutter run -d "$(or $(DEVICE),emulator)" --dart-define=API_BASE_URL=$(ANDROID_API_BASE_URL)

ios: ## Run on iOS Simulator (DEVICE="iPhone Air" or a UDID to pick a specific one)
	open -a Simulator
	flutter run -d "$(or $(DEVICE),iphone)" --dart-define=API_BASE_URL=$(API_BASE_URL)

build-web: ## Build for web (release)
	flutter build web --release --dart-define=API_BASE_URL=$(API_BASE_URL)

build-apk: ## Build release APK
	flutter build apk --release --dart-define=API_BASE_URL=$(API_BASE_URL)

build-ios: ## Build iOS archive (release)
	flutter build ios --release --dart-define=API_BASE_URL=$(API_BASE_URL)
