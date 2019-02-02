/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "D:/zzh_lyh_xcy/CPU/ID_MuxC.vhd";
extern char *IEEE_P_2592010699;



static void work_a_2424547062_3212880686_p_0(char *t0)
{
    char t26[16];
    char t28[16];
    char *t1;
    char *t2;
    char *t3;
    int t4;
    char *t5;
    char *t6;
    int t7;
    char *t8;
    char *t9;
    int t10;
    char *t11;
    char *t12;
    int t13;
    char *t14;
    int t16;
    char *t17;
    int t19;
    char *t20;
    char *t21;
    unsigned int t22;
    unsigned int t23;
    unsigned int t24;
    char *t25;
    char *t27;
    char *t29;
    char *t30;
    int t31;
    unsigned int t32;
    unsigned char t33;
    char *t34;
    char *t35;
    char *t36;
    char *t37;

LAB0:    xsi_set_current_line(18, ng0);
    t1 = (t0 + 1352U);
    t2 = *((char **)t1);
    t1 = (t0 + 4508);
    t4 = xsi_mem_cmp(t1, t2, 3U);
    if (t4 == 1)
        goto LAB3;

LAB10:    t5 = (t0 + 4511);
    t7 = xsi_mem_cmp(t5, t2, 3U);
    if (t7 == 1)
        goto LAB4;

LAB11:    t8 = (t0 + 4514);
    t10 = xsi_mem_cmp(t8, t2, 3U);
    if (t10 == 1)
        goto LAB5;

LAB12:    t11 = (t0 + 4517);
    t13 = xsi_mem_cmp(t11, t2, 3U);
    if (t13 == 1)
        goto LAB6;

LAB13:    t14 = (t0 + 4520);
    t16 = xsi_mem_cmp(t14, t2, 3U);
    if (t16 == 1)
        goto LAB7;

LAB14:    t17 = (t0 + 4523);
    t19 = xsi_mem_cmp(t17, t2, 3U);
    if (t19 == 1)
        goto LAB8;

LAB15:
LAB9:    xsi_set_current_line(32, ng0);
    t1 = (t0 + 4538);
    t3 = (t0 + 2912);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 4U);
    xsi_driver_first_trans_fast_port(t3);

LAB2:    t1 = (t0 + 2832);
    *((int *)t1) = 1;

LAB1:    return;
LAB3:    xsi_set_current_line(20, ng0);
    t20 = (t0 + 1032U);
    t21 = *((char **)t20);
    t22 = (8 - 8);
    t23 = (t22 * 1U);
    t24 = (0 + t23);
    t20 = (t21 + t24);
    t27 = ((IEEE_P_2592010699) + 4024);
    t29 = (t28 + 0U);
    t30 = (t29 + 0U);
    *((int *)t30) = 8;
    t30 = (t29 + 4U);
    *((int *)t30) = 6;
    t30 = (t29 + 8U);
    *((int *)t30) = -1;
    t31 = (6 - 8);
    t32 = (t31 * -1);
    t32 = (t32 + 1);
    t30 = (t29 + 12U);
    *((unsigned int *)t30) = t32;
    t25 = xsi_base_array_concat(t25, t26, t27, (char)99, (unsigned char)2, (char)97, t20, t28, (char)101);
    t32 = (1U + 3U);
    t33 = (4U != t32);
    if (t33 == 1)
        goto LAB17;

LAB18:    t30 = (t0 + 2912);
    t34 = (t30 + 56U);
    t35 = *((char **)t34);
    t36 = (t35 + 56U);
    t37 = *((char **)t36);
    memcpy(t37, t25, 4U);
    xsi_driver_first_trans_fast_port(t30);
    goto LAB2;

LAB4:    xsi_set_current_line(22, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t22 = (8 - 5);
    t23 = (t22 * 1U);
    t24 = (0 + t23);
    t1 = (t2 + t24);
    t5 = ((IEEE_P_2592010699) + 4024);
    t6 = (t28 + 0U);
    t8 = (t6 + 0U);
    *((int *)t8) = 5;
    t8 = (t6 + 4U);
    *((int *)t8) = 3;
    t8 = (t6 + 8U);
    *((int *)t8) = -1;
    t4 = (3 - 5);
    t32 = (t4 * -1);
    t32 = (t32 + 1);
    t8 = (t6 + 12U);
    *((unsigned int *)t8) = t32;
    t3 = xsi_base_array_concat(t3, t26, t5, (char)99, (unsigned char)2, (char)97, t1, t28, (char)101);
    t32 = (1U + 3U);
    t33 = (4U != t32);
    if (t33 == 1)
        goto LAB19;

LAB20:    t8 = (t0 + 2912);
    t9 = (t8 + 56U);
    t11 = *((char **)t9);
    t12 = (t11 + 56U);
    t14 = *((char **)t12);
    memcpy(t14, t3, 4U);
    xsi_driver_first_trans_fast_port(t8);
    goto LAB2;

LAB5:    xsi_set_current_line(24, ng0);
    t1 = (t0 + 4526);
    t3 = (t0 + 2912);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 4U);
    xsi_driver_first_trans_fast_port(t3);
    goto LAB2;

LAB6:    xsi_set_current_line(26, ng0);
    t1 = (t0 + 4530);
    t3 = (t0 + 2912);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 4U);
    xsi_driver_first_trans_fast_port(t3);
    goto LAB2;

LAB7:    xsi_set_current_line(28, ng0);
    t1 = (t0 + 4534);
    t3 = (t0 + 2912);
    t5 = (t3 + 56U);
    t6 = *((char **)t5);
    t8 = (t6 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 4U);
    xsi_driver_first_trans_fast_port(t3);
    goto LAB2;

LAB8:    xsi_set_current_line(30, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t22 = (8 - 2);
    t23 = (t22 * 1U);
    t24 = (0 + t23);
    t1 = (t2 + t24);
    t5 = ((IEEE_P_2592010699) + 4024);
    t6 = (t28 + 0U);
    t8 = (t6 + 0U);
    *((int *)t8) = 2;
    t8 = (t6 + 4U);
    *((int *)t8) = 0;
    t8 = (t6 + 8U);
    *((int *)t8) = -1;
    t4 = (0 - 2);
    t32 = (t4 * -1);
    t32 = (t32 + 1);
    t8 = (t6 + 12U);
    *((unsigned int *)t8) = t32;
    t3 = xsi_base_array_concat(t3, t26, t5, (char)99, (unsigned char)2, (char)97, t1, t28, (char)101);
    t32 = (1U + 3U);
    t33 = (4U != t32);
    if (t33 == 1)
        goto LAB21;

LAB22:    t8 = (t0 + 2912);
    t9 = (t8 + 56U);
    t11 = *((char **)t9);
    t12 = (t11 + 56U);
    t14 = *((char **)t12);
    memcpy(t14, t3, 4U);
    xsi_driver_first_trans_fast_port(t8);
    goto LAB2;

LAB16:;
LAB17:    xsi_size_not_matching(4U, t32, 0);
    goto LAB18;

LAB19:    xsi_size_not_matching(4U, t32, 0);
    goto LAB20;

LAB21:    xsi_size_not_matching(4U, t32, 0);
    goto LAB22;

}


extern void work_a_2424547062_3212880686_init()
{
	static char *pe[] = {(void *)work_a_2424547062_3212880686_p_0};
	xsi_register_didat("work_a_2424547062_3212880686", "isim/test7_isim_beh.exe.sim/work/a_2424547062_3212880686.didat");
	xsi_register_executes(pe);
}
