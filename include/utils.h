void clearCache (void);
void utils_start_timer(void);
void utils_stop_timer(void);
long long unsigned stop();
int utils_clean_matrices(float **a, float **b, float **c);
int utils_init_matrices(float ***a, float ***b, float ***c, int N);
void utils_setup_papi(int repetitions, const char *type);
void utils_results(const char *type);
#ifdef PAPI
void utils_start_papi(const char *type);
void utils_stop_papi(int rep, const char *type);
#endif