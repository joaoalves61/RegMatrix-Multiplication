#CC = /home/a77763/tools/gcc-4.9.3/bin/

BIN_NAME = main

CXX := icpc

ifeq ($(CXX),icpc)
	CXXFLAGS = -O3 -std=c++11 -Wno-unused-parameter -qopt-report=3 -qopenmp -static-libstdc++
else
	CXXFLAGS = -O3 -g -std=c++11 -fopt-info-vec-missed=build/report.fopt -fopenmp -Wunknown-pragmas
endif

# CXX = g++
# LD  = g++

#-fopenmp/-openmp for GNU/Intel

#

ifeq ($(VEC),no)
	CXXFLAGS += -no-vec
endif

ifeq ($(KNL),yes)
	CXXFLAGS += -march=knl 
endif

ifeq ($(PAPI),yes)
	CXXFLAGS += -I/share/apps/papi/5.5.0/include -L/share/apps/papi/5.5.0/lib -lpapi -DPAPI
endif

ifeq ($(DOT_PR_1),yes)
	CXXFLAGS += -DDOT_PR_1
endif

ifeq ($(DOT_PR_1_TR),yes)
	CXXFLAGS += -DDOT_PR_1_TR
endif

ifeq ($(DOT_PR_1_BL),yes)
	CXXFLAGS += -DDOT_PR_1_BL
endif

ifeq ($(DOT_PR_2),yes)
	CXXFLAGS += -DDOT_PR_2
endif

ifeq ($(DOT_PR_2_BL),yes)
	CXXFLAGS += -DDOT_PR_2_BL
endif

ifeq ($(DOT_PR_3),yes)
	CXXFLAGS += -DDOT_PR_3
endif

ifeq ($(DOT_PR_3_TR),yes)
	CXXFLAGS += -DDOT_PR_3_TR
endif

ifeq ($(DOT_PR_3_BL),yes)
	CXXFLAGS += -DDOT_PR_3_BL
endif

SRC_DIR = src
BIN_DIR = bin
BUILD_DIR = build
SRC = $(wildcard $(SRC_DIR)/*.cpp)
OBJ = $(patsubst src/%.cpp,build/%.o,$(SRC))
DEPS = $(patsubst build/%.o,build/%.d,$(OBJ))
BIN = $(BIN_NAME)

vpath %.cpp $(SRC_DIR)

.DEFAULT_GOAL = all

$(BUILD_DIR)/%.d: %.cpp
	$(CXX) -M $< -o $@ -lm $(CXXFLAGS)

$(BUILD_DIR)/%.o: %.cpp
	$(CXX) -c $< -o $@ -lm $(CXXFLAGS)

$(BIN_DIR)/$(BIN_NAME): $(DEPS) $(OBJ)
	$(CXX) -o $@ $(OBJ) -lm $(CXXFLAGS)

checkdirs:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BIN_DIR)

cuda:
	nvcc --dont-use-profile -ldir /home/a77763/tools/nvvm/libdevice -I/home/a77763/tools/include -L/home/a77763/tools/lib64 -ccbin=gcc src/MatrixMulot.cu -o bin/main_cuda

all: checkdirs $(BIN_DIR)/$(BIN_NAME)

run: clean all
	./bin/main

clean:
	rm -f $(BUILD_DIR)/* $(BIN_DIR)/*
