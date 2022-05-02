// #define GEOS_USE_ONLY_R_API 1

#include <stdio.h>
#include <stdlib.h>
#include <geos_c.h>

#define R(method, ...) method##_r(handle, __VA_ARGS__)

#define COLLINEAR_RING_R(handle, sequence) do {\
	GEOSCoordSeq_setXY_r(handle, sequence, 0, 1.0, 2.0);\
	GEOSCoordSeq_setXY_r(handle, sequence, 1, 1.0, 3.0);\
	GEOSCoordSeq_setXY_r(handle, sequence, 2, 1.0, 4.0);\
	GEOSCoordSeq_setXY_r(handle, sequence, 3, 1.0, 2.0);\
} while(0)

static void print_ring(const GEOSContextHandle_t handle, const GEOSGeom ring)
{
	const struct GEOSCoordSeq_t *coordinates;
	unsigned size;
	double x, y;

	coordinates = GEOSGeom_getCoordSeq_r(handle, ring);

	R(GEOSCoordSeq_getSize, coordinates, &size);
	//GEOSCoordSeq_getSize_r(handle, coordinates, &size);

	printf("[");
	for (unsigned i = 0; i < size; i++)
	{
		if (i) printf(", ");

		GEOSCoordSeq_getXY_r(handle, coordinates, i, &x, &y);
		printf("[%f, %f]", x, y);
	}
	printf("]\n");
}


void Init_some() {
	GEOSContextHandle_t handle;
	GEOSGeom ring;
	GEOSGeom valid_ring;
	struct GEOSCoordSeq_t *sequence;
	char is_ccw;
	char *is_valid_reason;

	handle = GEOS_init_r();
	// TODO: understand that
	// GEOSContext_setErrorHandler_r(handle, ???);

	sequence = GEOSCoordSeq_create_r(handle, 4, 2);
	COLLINEAR_RING_R(handle, sequence);

	ring = GEOSGeom_createLinearRing_r(handle, sequence);
	printf("ring? == %s\n", GEOSisRing_r(handle, ring) ? "true" : "false");
	valid_ring = GEOSMakeValid_r(handle, ring);

	print_ring(handle, ring);

	if (valid_ring) {
		print_ring(handle, valid_ring);
	}

	switch (GEOSisValid_r(handle, ring))
	{
		case 0: // false
			is_valid_reason = GEOSisValidReason_r(handle, ring);
			printf("valid? false (%s)\n", is_valid_reason);
			GEOSFree_r(handle, is_valid_reason);
			break;
		case 1: // true
			printf("valid? true\n");
			break;
		case 2: // exception
			printf("RESULT: exception\n");
			break;
	};

	if (GEOSCoordSeq_isCCW_r(handle, sequence, &is_ccw))
	{
		printf("ccw? %s\n", is_ccw ? "true" : "false");
	} else {
		printf("exception in GEOSCoordSeq_isCCW_r.");
	}

	GEOSGeom_destroy_r(handle, ring);
	// QUESTION: why is that causing an exception ?
	// GEOSCoordSeq_destroy_r(handle, sequence);
	GEOS_finish_r(handle);
	// GEOSGeom_destroy_r(GEOSContextHandle_t handle, GEOSGeometry* g) for all GEOSGeom
	// GEOSFree_r(GEOSContextHandle_t handle, void *buffer) for all char * except const

}
