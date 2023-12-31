#ifndef __GPU_KPI_WRAP_DEF_H
#define __GPU_KPI_WRAP_DEF_H

typedef void* GED_KPI_HANDLE;

typedef enum GED_ERROR_TAG {
	GED_OK,
	GED_ERROR_FAIL,
	GED_ERROR_OOM ,
	GED_ERROR_OUT_OF_FD,
	GED_ERROR_FAIL_WITH_LIMIT,
	GED_ERROR_TIMEOUT,
	GED_ERROR_CMD_NOT_PROCESSED,
	GED_ERROR_INVALID_PARAMS,
	GED_ERROR_INTENTIONAL_BLOCK,
} GED_ERROR;

#endif
