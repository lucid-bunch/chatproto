.DEFAULT_GOAL := stubs

PROTO_FILES = $(wildcard $(PROTO_DIR)/*.proto)
SERVICES = $(patsubst %.proto,%,$(notdir $(PROTO_FILES)))
PROTO_DIR = proto
OUTPUT_DIR = build
PB_GO_SUFFIX = .pb.go
MKDIR_P = mkdir -p
RMDIR = rm -rf

# make sure output dir is created
${OUTPUT_DIR}:
	${MKDIR_P} ${OUTPUT_DIR}

# default goal to generate protobuf stubs
.PHONY: stubs
stubs: _dirs _go

# wipe clean
.PHONY: clean
clean: _dirs
	${RMDIR} ${OUTPUT_DIR}

# create necessary directories
.PHONY: _dirs
_dirs: ${OUTPUT_DIR}

# generates go protobuf stubs
.PHONY: _go
_go: $(addprefix $(OUTPUT_DIR)/,$(addsuffix $(PB_GO_SUFFIX),$(SERVICES)))
$(OUTPUT_DIR)/%$(PB_GO_SUFFIX): $(PROTO_DIR)/%.proto
	protoc \
	-I $(PROTO_DIR) \
	--go_out=plugins=grpc:$(OUTPUT_DIR) \
	$<
