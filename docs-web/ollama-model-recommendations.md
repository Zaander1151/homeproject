# Ollama Model Recommendations (8GB VRAM)

**GPU Constraint:** 8GB VRAM
**Current Models:** 18 models installed (4.7GB average size)
**Date:** 2025-12-03

## Currently Installed Models

| Model | Size | Primary Use | Notes |
|-------|------|-------------|-------|
| `qwen3:8b` | 5.2 GB | **PRIMARY** - Task delegation, code analysis | Best performance for agents |
| `qwen2.5:7b` | 4.7 GB | General purpose | Recently added |
| `qwen2.5-coder:7b` | 4.7 GB | Code generation | Excellent for coding tasks |
| `deepseek-r1:8b` | 5.2 GB | Reasoning tasks | Strong analytical capabilities |
| `deepseek-coder:6.7b` | 3.8 GB | Code-specific | Good for development |
| `llama3.1:8b-instruct-q4_K_M` | 4.9 GB | General instruction following | Meta's latest |
| `llama3:8b` | 4.7 GB | General purpose | Reliable baseline |
| `llama3.2:latest` | 2.0 GB | Lightweight general | Fast inference |
| `mistral:latest` | 4.4 GB | General purpose | Strong performer |
| `dolphin-mistral:7b` | 4.1 GB | Uncensored variant | Flexible responses |
| `llama2-uncensored:7b` | 3.8 GB | Uncensored variant | Legacy |
| `granite4:micro` | 2.1 GB | Lightweight | IBM's efficient model |
| `codellama:7b` | 3.8 GB | Code generation | Meta's code model |
| `allenporter/assist-llm:latest` | 4.9 GB | Home Assistant specific | Specialized for HA |
| `EntropyYue/longwriter-glm4:9b` | 5.5 GB | Long-form writing | Document generation |
| `adi0adi/ollama_stheno-8b_v3.1_q6k` | 6.6 GB | Creative writing | Fine-tuned variant |
| `hf.co/bartowski/llama-3-fantasy-writer-8b` | 4.9 GB | Creative writing | Specialized |
| `llama2:latest` | 3.8 GB | Legacy general purpose | Old version |

**Total Storage:** ~75 GB across 18 models

---

## Recommended Additions

### HIGH PRIORITY - Fill Critical Gaps

#### 1. Vision/Multimodal Models

**Moondream (1.8B) - HIGHLY RECOMMENDED**
```bash
docker exec ollama ollama pull moondream
```
- **Size:** ~1.1 GB
- **VRAM:** ~2 GB when running
- **Use Case:** Image analysis for TripoSR workflow, security camera analysis, visual troubleshooting
- **Why:** Only vision model that fits comfortably in 8GB VRAM
- **Agent Integration:**
  - Media Server Curator: Analyze movie posters, thumbnails
  - 3D Printing Workflow: Validate generated models from TripoSR
  - Smart Home: Analyze security camera feeds, visual device status

**LLaVA-Phi3 (3.8B)**
```bash
docker exec ollama ollama pull llava-phi3
```
- **Size:** ~2.2 GB
- **VRAM:** ~4.5 GB when running
- **Use Case:** More capable vision model, better reasoning with images
- **Why:** Microsoft Phi3 base with vision capabilities
- **Trade-off:** Larger but more accurate than Moondream

**Recommendation:** Start with **Moondream** for testing, add LLaVA-Phi3 if you need better accuracy.

---

#### 2. Embedding Models - CRITICAL FOR FUTURE AGENTS

**Nomic-Embed-Text - HIGHLY RECOMMENDED**
```bash
docker exec ollama ollama pull nomic-embed-text
```
- **Size:** ~274 MB
- **VRAM:** ~500 MB when running
- **Use Case:** Semantic search, document similarity, knowledge base indexing
- **Why:** Best open-source embedding model, 8192 token context
- **Agent Integration:**
  - All agents: Build searchable knowledge bases of issues/solutions
  - Automation Architect: Find similar automation patterns
  - Voice Assistant Trainer: Semantic intent matching
  - Documentation search across all your configs

**Mxbai-Embed-Large (335M)**
```bash
docker exec ollama ollama pull mxbai-embed-large
```
- **Size:** ~669 MB
- **VRAM:** ~1 GB when running
- **Use Case:** Alternative embedding model, state-of-the-art performance
- **Why:** Often outperforms nomic-embed-text on certain tasks
- **Trade-off:** Slightly larger but potentially more accurate

**Recommendation:** Install **nomic-embed-text** immediately. This is essential for building agent knowledge bases.

---

#### 3. Code Models - Upgrades

**Yi-Coder 1.5B - RECOMMENDED**
```bash
docker exec ollama ollama pull yi-coder:1.5b
```
- **Size:** ~900 MB
- **VRAM:** ~2 GB when running
- **Use Case:** Fast code completion, lightweight coding assistant
- **Why:** Faster than 7B models for simple tasks, excellent performance for size
- **Agent Integration:**
  - ESP32 Device Manager: Generate ESPHome configs quickly
  - Code review for simple changes
- **vs. Current:** Faster than qwen2.5-coder:7b for simple tasks

**StarCoder2 3B - RECOMMENDED**
```bash
docker exec ollama ollama pull starcoder2:3b
```
- **Size:** ~1.7 GB
- **VRAM:** ~3 GB when running
- **Use Case:** Multi-language code generation, 80+ programming languages
- **Why:** Broader language support than current models
- **Agent Integration:**
  - Supports more languages (Go, Rust, etc.)
  - Better for infrastructure-as-code (Docker, YAML)

---

#### 4. Specialized Models

**Llama 3.2 Vision 11B - STRETCH GOAL**
```bash
docker exec ollama ollama pull llama3.2-vision:11b
```
- **Size:** ~7.9 GB
- **VRAM:** ~9 GB when running (EXCEEDS YOUR LIMIT)
- **Use Case:** Most capable vision model
- **Why:** Meta's latest vision-language model
- **⚠️ Warning:** Will NOT fit in 8GB VRAM during inference
- **Alternative:** Use via Gemini API instead

**Aya 8B - OPTIONAL**
```bash
docker exec ollama ollama pull aya:8b
```
- **Size:** ~4.8 GB
- **VRAM:** ~6 GB when running
- **Use Case:** Multilingual support (23 languages)
- **Why:** Best multilingual model under 8B
- **Relevance:** Low priority unless you need non-English support

---

### MEDIUM PRIORITY - Nice to Have

#### 5. Faster Lightweight Models

**Phi 3.5 (3.8B)**
```bash
docker exec ollama ollama pull phi3.5
```
- **Size:** ~2.2 GB
- **VRAM:** ~3.5 GB when running
- **Use Case:** Fast general-purpose queries, low-latency responses
- **Why:** Microsoft's highly optimized small model
- **Agent Integration:** Ultra-fast responses for simple queries

**Gemma 2 2B**
```bash
docker exec ollama ollama pull gemma2:2b
```
- **Size:** ~1.6 GB
- **VRAM:** ~2.5 GB when running
- **Use Case:** Extremely fast inference, simple tasks
- **Why:** Google's efficient small model
- **Agent Integration:** Quick health checks, log parsing

---

### LOW PRIORITY - Overlaps with Existing

**Qwen 2.5 (not coder variant)** - Already have qwen3:8b
**Llama 3.3** - Already have llama3.1:8b
**CodeGemma** - Already have qwen2.5-coder and deepseek-coder
**InternLM2** - Overlaps with existing models

---

## Recommended Installation Order

### Phase 1: Critical Gaps (Install Now)
```bash
# Embedding model - ESSENTIAL for agent knowledge bases
docker exec ollama ollama pull nomic-embed-text        # 274 MB

# Vision model - Enable image analysis
docker exec ollama ollama pull moondream               # 1.1 GB

# Fast code model - Lightweight coding
docker exec ollama ollama pull yi-coder:1.5b           # 900 MB

# Total: ~2.3 GB additional
```

### Phase 2: Enhanced Capabilities (Next)
```bash
# Better vision model
docker exec ollama ollama pull llava-phi3              # 2.2 GB

# Multi-language code support
docker exec ollama ollama pull starcoder2:3b           # 1.7 GB

# Fast general purpose
docker exec ollama ollama pull phi3.5                  # 2.2 GB

# Total: ~6.1 GB additional
```

### Phase 3: Optional Enhancements (Later)
```bash
# Alternative embedding
docker exec ollama ollama pull mxbai-embed-large       # 669 MB

# Ultra-lightweight
docker exec ollama ollama pull gemma2:2b               # 1.6 GB

# Multilingual (if needed)
docker exec ollama ollama pull aya:8b                  # 4.8 GB
```

---

## Models to Consider Removing

Based on overlap and usage:

### Low Priority for Removal
- **`llama2:latest`** (3.8 GB) - Superseded by llama3.x models
- **`llama2-uncensored:7b`** (3.8 GB) - Have dolphin-mistral for uncensored
- **`codellama:7b`** (3.8 GB) - Superseded by qwen2.5-coder and deepseek-coder
- **`granite4:micro`** (2.1 GB) - Limited use case

**Potential Space Reclaimed:** ~12 GB

### Specialized - Keep if Used
- **`hf.co/bartowski/llama-3-fantasy-writer-8b`** - Only if you use for creative writing
- **`EntropyYue/longwriter-glm4:9b`** - Only if you generate long documents
- **`adi0adi/ollama_stheno-8b_v3.1_q6k`** - Only if you use for creative tasks

---

## VRAM Usage Analysis

**Single Model Inference (typical):**
- 8B model: ~6 GB VRAM
- 7B model: ~5 GB VRAM
- 3B model: ~3 GB VRAM
- 1B model: ~2 GB VRAM

**Your 8GB VRAM can comfortably run:**
- ✅ Any single 8B model
- ✅ One 7B model + small tasks
- ⚠️ NOT simultaneous large models
- ❌ NOT 11B+ models

**Recommendation:** Models are loaded on-demand. Having more models doesn't affect VRAM unless actively running.

---

## Agent-Specific Recommendations

### Network Administrator Agent
- **Primary:** `qwen3:8b` (already installed) ✅
- **Fast checks:** Add `phi3.5` for quick diagnostics

### Media Server Curator Agent
- **Analysis:** `qwen3:8b` ✅
- **Vision:** Add `moondream` for image analysis ⭐
- **Embedding:** Add `nomic-embed-text` for duplicate detection ⭐

### Voice Assistant Trainer Agent
- **Primary:** `qwen3:8b` ✅
- **Embedding:** Add `nomic-embed-text` for semantic matching ⭐

### ESP32 Device Manager Agent
- **Config generation:** Add `yi-coder:1.5b` for fast configs ⭐
- **Analysis:** `qwen3:8b` ✅

### Smart Home Health Monitor
- **Primary:** `qwen3:8b` ✅
- **Fast checks:** Add `phi3.5` for rapid health checks

### 3D Printing Workflow Agent
- **Vision:** Add `moondream` for STL previews ⭐
- **Primary:** `qwen3:8b` ✅

### Automation Architect Agent
- **Primary:** Use Gemini API (requires creativity beyond local models)
- **Embedding:** Add `nomic-embed-text` for pattern matching ⭐

---

## Testing New Models

**Template for testing:**
```bash
# Pull model
docker exec ollama ollama pull <model_name>

# Test performance
docker exec ollama ollama run <model_name> "Explain Docker networking in 2 sentences"

# Check VRAM usage
nvidia-smi

# Remove if not suitable
docker exec ollama ollama rm <model_name>
```

---

## Summary: Top 3 Additions

For maximum impact with minimal storage:

1. **nomic-embed-text** (~274 MB) - Critical for agent knowledge bases
2. **moondream** (~1.1 GB) - Enable vision capabilities
3. **yi-coder:1.5b** (~900 MB) - Fast code generation

**Total additional storage:** ~2.3 GB
**VRAM impact:** None (models load on-demand)
**Agent enhancement:** Massive (adds vision + semantic search)

---

**Last Updated:** 2025-12-03
**Next Review:** After Phase 1 installation and testing
