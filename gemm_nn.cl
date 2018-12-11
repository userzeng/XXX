__kernel void
gemm_nn(int m, int n, int k, float alpha, __global float *A, int lda,
        __global float *B, int ldb, __global float *C, int ldc)
{
	const int local_row = get_local_id(0);
	const int local_col = get_local_id(1);

	enum {tile_size = 32};
	__local float tile_A[tile_size][tile_size];
	__local float tile_B[tile_size][tile_size];

	const int global_row = get_group_id(0) * tile_size + local_row;
	const int global_col = get_group_id(1) * tile_size + local_col;
	
	float acc = 0;
	const int ntiles = k / tile_size;
	for (int i = 0; i < ntiles; ++i) {
		tile_A[local_row][local_col] = A[global_row * lda + i * tile_size + local_col];
		tile_B[local_row][local_col] = B[(i * tile_size + local_row) * ldb + global_col];
		
		barrier(CLK_LOCAL_MEM_FENCE);
		
		for (int j = 0; j < tile_size; ++j) {
			acc += alpha * tile_A[local_row][j] * tile_B[j][local_col];
		}
		
		barrier(CLK_LOCAL_MEM_FENCE);
	}
	
	C[global_row * ldc + global_col] += acc;
}