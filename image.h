#ifndef _IMAGE_H_
#define _IMAGE_H_

#include "convnet.h"
#include "bmp.h"

#ifdef __cplusplus
extern "C"
{
#endif

image *create_image(int width, int height, int nchannels);
void free_image(image *img);
void split_channel(const unsigned char *const src, image *dst);
void resize_image(image *src, image *dst);
void embed_image(image *src, image *dst);
void set_image(image *img, float val);

#ifdef __cplusplus
}
#endif

#endif