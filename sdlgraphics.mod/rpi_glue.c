#include <stdio.h>
#include <math.h>
#include "interface/vmcs_host/vc_tvservice.h"

static int start_mode;
static int start_group;
static int start_width;
static int start_height;

void bmx_tvservice_init() {
	int w, h, f, m, g;

	vcos_init();
	
	VCHI_INSTANCE_T instance;
	VCHI_CONNECTION_T connection;
	
	vchi_initialise(&instance);
	
	vchi_connect(NULL, 0, instance);
	
	vc_vchi_tv_init(instance, &connection, 1);
	
	
	bmx_tvservice_currentres(&w, &h, &f, &m, &g);
	start_mode = m;
	start_group = g;
	start_width = w;
	start_height = h;
}


void bmx_tvservice_currentres(int * width, int * height, float * framerate, int * mode, int * group) {
	TV_DISPLAY_STATE_T state;
	
	if (vc_tv_get_display_state(&state) == 0) {
	
		HDMI_PROPERTY_PARAM_T property;
		property.property = HDMI_PROPERTY_PIXEL_CLOCK_TYPE;
		
		vc_tv_hdmi_get_property(&property);
		
		//float framerate;
		
		if (property.param1 == HDMI_PIXEL_CLOCK_TYPE_NTSC) {
			*framerate = state.display.hdmi.frame_rate * (1000.0f / 1001.0f);
		} else {
			*framerate = state.display.hdmi.frame_rate;
		}
		
		*width = state.display.hdmi.width;
		*height = state.display.hdmi.height;
		*mode = state.display.hdmi.mode;
		*group = state.display.hdmi.group;
	
	}
	
}

int bmx_tvservice_modes(int * imodes, int maxcount, int with_mode) {
	TV_SUPPORTED_MODE_NEW_T supported_modes[127];
	HDMI_RES_GROUP_T group, preferred_group;
	uint32_t preferred_mode;
	int count, mode_count, i, n;
	
	count = 0;
	
	for (i = 0; i < 2; i++) {

		memset(supported_modes, 0, sizeof(supported_modes));
	
		switch (i) {
			case 0:
				group = HDMI_RES_GROUP_CEA;
				break;
			case 1:
				group = HDMI_RES_GROUP_DMT;
				break;
		}
	
		mode_count = vc_tv_hdmi_get_supported_modes_new(group, supported_modes, vcos_countof(supported_modes),
				&preferred_group, &preferred_mode);
		
		for (n = 0; n < mode_count; n++) {
			*imodes++ = supported_modes[n].width;
			*imodes++ = supported_modes[n].height;
			*imodes++ = 16;
			*imodes++ = supported_modes[n].frame_rate;
			
			if (with_mode) {
				*imodes++ = supported_modes[n].code;
				*imodes++ = group;
			}
			
			count++;
			
			if (maxcount < count) {
				break;
			}
		}
	}
	
	return count;
}

void bmx_tvservice_get_closest_mode(int width, int height, int framerate, int * mode, int * group) {
	int modes[127 * 6];
	int count, i;
	*mode = -1;
	*group = -1;
	int * p;
	int closest_prod = -1;
	int closest_hz = -1;
	int closest_mode = -1;
	int closest_group = -1;
	int product = width * height;
	int better_match;
	
	count = bmx_tvservice_modes(&modes, 127, 1);
	
	p = &modes;
	
	for (i = 0; i < count; i++) {
		
		better_match = 0;
		
		if (width <= p[0] && height <= p[1]) {
			
			// found a closer res?
			if (abs(p[0] * p[1] - product) <= abs(closest_prod - product)) {
				
				// an exact match?
				if ((p[0] * p[1] == product) && framerate == p[3]) {
					*mode = p[4];
					*group = p[5];
					break;
				}

				if (p[0] * p[1] == closest_prod) {
					
					// is hz a better match?
					if (p[3] > closest_hz) {
						if (abs(framerate-p[3]) < abs(framerate-closest_hz)) {
							better_match = 1;
						}
					}
					
				} else {
					better_match = 1;
				}
				
				if (better_match) {
					closest_prod = p[0] * p[1];
					closest_hz = p[3];
					closest_mode = p[4];
					closest_group = p[5];
				}

			}
		}
		
		p += 6;
	}
	
	// did we already find an exact match?
	// no
	if (*mode < 0) {
		// pick the closest
		*mode = closest_mode;
		*group = closest_group;
	}
}

void bmx_tvservice_setmode(int mode, int group, int width, int height) {
	// set the tv mode
	//vc_tv_hdmi_power_on_explicit_new(((group==0) || (group == HDMI_RES_GROUP_CEA))?HDMI_RES_GROUP_CEA:HDMI_RES_GROUP_DMT, mode, HDMI_MODE_HDMI);
	char buf[255];

	snprintf(buf, 255, "tvservice -e \"%s %d %s\"",((group==0) || (group == HDMI_RES_GROUP_CEA))? "CEA":"DMT", mode, "HDMI");
	system(buf);
	
	sleep(1);
	
	// reset the framebuffer
	//system("fbset -depth 8 && fbset -depth 16");
	//snprintf(buf, 255, "fbset -xres %d -yres %d -depth 8 && fbset -depth 16", width, height);
//printf("%s\n", buf);fflush(stdout);
//	system(buf);
}

void bmx_reset_screen() {
	bmx_tvservice_setmode(start_mode, start_group, start_width, start_height);
	system("fbset -depth 8 && fbset -depth 16");
}
