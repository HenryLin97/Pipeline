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

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_2592010699;
char *IEEE_P_3620187407;
char *IEEE_P_3499444699;
char *STD_STANDARD;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    work_a_1991350011_3212880686_init();
    work_a_2717587577_3212880686_init();
    work_a_3748633682_3212880686_init();
    work_a_2424006887_3212880686_init();
    work_a_3195375216_3212880686_init();
    work_a_2281222837_3212880686_init();
    work_a_2424547062_3212880686_init();
    work_a_3949508039_3212880686_init();
    work_a_1350853198_3212880686_init();
    work_a_3092466070_3212880686_init();
    work_a_0896209541_3212880686_init();
    work_a_3083307733_3212880686_init();
    work_a_2387260944_3212880686_init();
    work_a_0832606739_3212880686_init();
    work_a_0194007155_3212880686_init();
    work_a_2271419722_3212880686_init();
    work_a_2499866819_3212880686_init();
    work_a_1991058128_3212880686_init();
    work_a_3222946569_3212880686_init();
    work_a_1478196689_3212880686_init();
    work_a_3946787226_3212880686_init();
    work_a_3501749534_3212880686_init();
    work_a_1415465652_3212880686_init();
    work_a_1829962170_2372691052_init();


    xsi_register_tops("work_a_1829962170_2372691052");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    STD_STANDARD = xsi_get_engine_memory("std_standard");

    return xsi_run_simulation(argc, argv);

}
