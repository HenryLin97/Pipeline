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
static const char *ng0 = "D:/zzh_lyh_xcy/CPU/CLK_Unit.vhd";
extern char *IEEE_P_2592010699;

unsigned char ieee_p_2592010699_sub_1744673427_503743352(char *, char *, unsigned int , unsigned int );


static void work_a_3501749534_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    int t9;
    char *t10;

LAB0:    xsi_set_current_line(17, ng0);
    t1 = (t0 + 1032U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 1152U);
    t3 = ieee_p_2592010699_sub_1744673427_503743352(IEEE_P_2592010699, t1, 0U, 0U);
    if (t3 != 0)
        goto LAB5;

LAB6:
LAB3:    t1 = (t0 + 2952);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(18, ng0);
    t1 = (t0 + 3032);
    t5 = (t1 + 56U);
    t6 = *((char **)t5);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    *((unsigned char *)t8) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    goto LAB3;

LAB5:    xsi_set_current_line(20, ng0);
    t2 = (t0 + 1648U);
    t5 = *((char **)t2);
    t9 = *((int *)t5);
    if (t9 == 0)
        goto LAB8;

LAB12:    if (t9 == 1)
        goto LAB9;

LAB13:    if (t9 == 2)
        goto LAB10;

LAB14:
LAB11:
LAB7:    goto LAB3;

LAB8:    xsi_set_current_line(22, ng0);
    t2 = (t0 + 3032);
    t6 = (t2 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t10 = *((char **)t8);
    *((unsigned char *)t10) = (unsigned char)3;
    xsi_driver_first_trans_fast_port(t2);
    xsi_set_current_line(23, ng0);
    t1 = (t0 + 1648U);
    t2 = *((char **)t1);
    t1 = (t2 + 0);
    *((int *)t1) = 1;
    t5 = (t0 + 1592U);
    xsi_variable_act(t5);
    goto LAB7;

LAB9:    xsi_set_current_line(25, ng0);
    t1 = (t0 + 3032);
    t2 = (t1 + 56U);
    t5 = *((char **)t2);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    *((unsigned char *)t7) = (unsigned char)2;
    xsi_driver_first_trans_fast_port(t1);
    xsi_set_current_line(26, ng0);
    t1 = (t0 + 1648U);
    t2 = *((char **)t1);
    t1 = (t2 + 0);
    *((int *)t1) = 2;
    t5 = (t0 + 1592U);
    xsi_variable_act(t5);
    goto LAB7;

LAB10:    xsi_set_current_line(28, ng0);
    t1 = (t0 + 1648U);
    t2 = *((char **)t1);
    t1 = (t2 + 0);
    *((int *)t1) = 0;
    t5 = (t0 + 1592U);
    xsi_variable_act(t5);
    goto LAB7;

LAB15:;
}


extern void work_a_3501749534_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3501749534_3212880686_p_0};
	xsi_register_didat("work_a_3501749534_3212880686", "isim/test8_isim_beh.exe.sim/work/a_3501749534_3212880686.didat");
	xsi_register_executes(pe);
}
