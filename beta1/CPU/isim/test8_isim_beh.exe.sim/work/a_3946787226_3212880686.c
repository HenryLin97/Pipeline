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
static const char *ng0 = "D:/zzh_lyh_xcy/CPU/Forward_Unit.vhd";



static void work_a_3946787226_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t9;
    char *t10;
    unsigned char t11;
    unsigned char t12;
    unsigned char t13;
    unsigned char t14;
    unsigned char t15;
    unsigned int t16;
    char *t17;
    unsigned char t18;
    unsigned int t19;
    char *t20;
    char *t21;
    char *t22;
    char *t23;
    char *t24;
    unsigned char t25;
    unsigned int t26;
    char *t27;
    char *t28;
    char *t29;
    char *t30;
    char *t31;
    char *t32;
    char *t33;
    char *t34;
    char *t35;

LAB0:    xsi_set_current_line(56, ng0);
    t1 = (t0 + 2472U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 2272U);
    t4 = xsi_signal_has_event(t1);
    if (t4 == 1)
        goto LAB7;

LAB8:    t3 = (unsigned char)0;

LAB9:    if (t3 != 0)
        goto LAB5;

LAB6:
LAB3:    t1 = (t0 + 3952);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(57, ng0);
    t1 = (t0 + 6120);
    t6 = (t0 + 4032);
    t7 = (t6 + 56U);
    t8 = *((char **)t7);
    t9 = (t8 + 56U);
    t10 = *((char **)t9);
    memcpy(t10, t1, 2U);
    xsi_driver_first_trans_fast_port(t6);
    xsi_set_current_line(58, ng0);
    t1 = (t0 + 6122);
    t5 = (t0 + 4096);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 2U);
    xsi_driver_first_trans_fast_port(t5);
    goto LAB3;

LAB5:    xsi_set_current_line(63, ng0);
    t2 = (t0 + 1352U);
    t6 = *((char **)t2);
    t2 = (t0 + 1032U);
    t7 = *((char **)t2);
    t15 = 1;
    if (4U == 4U)
        goto LAB19;

LAB20:    t15 = 0;

LAB21:    if (t15 == 1)
        goto LAB16;

LAB17:    t14 = (unsigned char)0;

LAB18:    if (t14 == 1)
        goto LAB13;

LAB14:    t13 = (unsigned char)0;

LAB15:    if (t13 != 0)
        goto LAB10;

LAB12:    t1 = (t0 + 1352U);
    t2 = *((char **)t1);
    t1 = (t0 + 1192U);
    t5 = *((char **)t1);
    t11 = 1;
    if (4U == 4U)
        goto LAB45;

LAB46:    t11 = 0;

LAB47:    if (t11 == 1)
        goto LAB42;

LAB43:    t4 = (unsigned char)0;

LAB44:    if (t4 == 1)
        goto LAB39;

LAB40:    t3 = (unsigned char)0;

LAB41:    if (t3 != 0)
        goto LAB37;

LAB38:    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t1 = (t0 + 1032U);
    t5 = *((char **)t1);
    t11 = 1;
    if (4U == 4U)
        goto LAB71;

LAB72:    t11 = 0;

LAB73:    if (t11 == 1)
        goto LAB68;

LAB69:    t4 = (unsigned char)0;

LAB70:    if (t4 == 1)
        goto LAB65;

LAB66:    t3 = (unsigned char)0;

LAB67:    if (t3 != 0)
        goto LAB63;

LAB64:    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t1 = (t0 + 1192U);
    t5 = *((char **)t1);
    t11 = 1;
    if (4U == 4U)
        goto LAB97;

LAB98:    t11 = 0;

LAB99:    if (t11 == 1)
        goto LAB94;

LAB95:    t4 = (unsigned char)0;

LAB96:    if (t4 == 1)
        goto LAB91;

LAB92:    t3 = (unsigned char)0;

LAB93:    if (t3 != 0)
        goto LAB89;

LAB90:    xsi_set_current_line(72, ng0);
    t1 = (t0 + 6160);
    t5 = (t0 + 4032);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 2U);
    xsi_driver_first_trans_fast_port(t5);

LAB11:    xsi_set_current_line(75, ng0);
    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t1 = (t0 + 1032U);
    t5 = *((char **)t1);
    t11 = 1;
    if (4U == 4U)
        goto LAB124;

LAB125:    t11 = 0;

LAB126:    if (t11 == 1)
        goto LAB121;

LAB122:    t4 = (unsigned char)0;

LAB123:    if (t4 == 1)
        goto LAB118;

LAB119:    t3 = (unsigned char)0;

LAB120:    if (t3 != 0)
        goto LAB115;

LAB117:    t1 = (t0 + 1512U);
    t2 = *((char **)t1);
    t1 = (t0 + 1192U);
    t5 = *((char **)t1);
    t11 = 1;
    if (4U == 4U)
        goto LAB150;

LAB151:    t11 = 0;

LAB152:    if (t11 == 1)
        goto LAB147;

LAB148:    t4 = (unsigned char)0;

LAB149:    if (t4 == 1)
        goto LAB144;

LAB145:    t3 = (unsigned char)0;

LAB146:    if (t3 != 0)
        goto LAB142;

LAB143:    xsi_set_current_line(80, ng0);
    t1 = (t0 + 6180);
    t5 = (t0 + 4096);
    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t8 = (t7 + 56U);
    t9 = *((char **)t8);
    memcpy(t9, t1, 2U);
    xsi_driver_first_trans_fast_port(t5);

LAB116:    goto LAB3;

LAB7:    t2 = (t0 + 2312U);
    t5 = *((char **)t2);
    t11 = *((unsigned char *)t5);
    t12 = (t11 == (unsigned char)2);
    t3 = t12;
    goto LAB9;

LAB10:    xsi_set_current_line(64, ng0);
    t29 = (t0 + 6131);
    t31 = (t0 + 4032);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    t34 = (t33 + 56U);
    t35 = *((char **)t34);
    memcpy(t35, t29, 2U);
    xsi_driver_first_trans_fast_port(t31);
    goto LAB11;

LAB13:    t22 = (t0 + 1672U);
    t23 = *((char **)t22);
    t22 = (t0 + 6128);
    t25 = 1;
    if (3U == 3U)
        goto LAB31;

LAB32:    t25 = 0;

LAB33:    t13 = t25;
    goto LAB15;

LAB16:    t9 = (t0 + 1352U);
    t10 = *((char **)t9);
    t9 = (t0 + 6124);
    t18 = 1;
    if (4U == 4U)
        goto LAB25;

LAB26:    t18 = 0;

LAB27:    t14 = (!(t18));
    goto LAB18;

LAB19:    t16 = 0;

LAB22:    if (t16 < 4U)
        goto LAB23;
    else
        goto LAB21;

LAB23:    t2 = (t6 + t16);
    t8 = (t7 + t16);
    if (*((unsigned char *)t2) != *((unsigned char *)t8))
        goto LAB20;

LAB24:    t16 = (t16 + 1);
    goto LAB22;

LAB25:    t19 = 0;

LAB28:    if (t19 < 4U)
        goto LAB29;
    else
        goto LAB27;

LAB29:    t20 = (t10 + t19);
    t21 = (t9 + t19);
    if (*((unsigned char *)t20) != *((unsigned char *)t21))
        goto LAB26;

LAB30:    t19 = (t19 + 1);
    goto LAB28;

LAB31:    t26 = 0;

LAB34:    if (t26 < 3U)
        goto LAB35;
    else
        goto LAB33;

LAB35:    t27 = (t23 + t26);
    t28 = (t22 + t26);
    if (*((unsigned char *)t27) != *((unsigned char *)t28))
        goto LAB32;

LAB36:    t26 = (t26 + 1);
    goto LAB34;

LAB37:    xsi_set_current_line(66, ng0);
    t27 = (t0 + 6140);
    t29 = (t0 + 4032);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    memcpy(t33, t27, 2U);
    xsi_driver_first_trans_fast_port(t29);
    goto LAB11;

LAB39:    t20 = (t0 + 1672U);
    t21 = *((char **)t20);
    t20 = (t0 + 6137);
    t13 = 1;
    if (3U == 3U)
        goto LAB57;

LAB58:    t13 = 0;

LAB59:    t3 = t13;
    goto LAB41;

LAB42:    t7 = (t0 + 1352U);
    t8 = *((char **)t7);
    t7 = (t0 + 6133);
    t12 = 1;
    if (4U == 4U)
        goto LAB51;

LAB52:    t12 = 0;

LAB53:    t4 = (!(t12));
    goto LAB44;

LAB45:    t16 = 0;

LAB48:    if (t16 < 4U)
        goto LAB49;
    else
        goto LAB47;

LAB49:    t1 = (t2 + t16);
    t6 = (t5 + t16);
    if (*((unsigned char *)t1) != *((unsigned char *)t6))
        goto LAB46;

LAB50:    t16 = (t16 + 1);
    goto LAB48;

LAB51:    t19 = 0;

LAB54:    if (t19 < 4U)
        goto LAB55;
    else
        goto LAB53;

LAB55:    t10 = (t8 + t19);
    t17 = (t7 + t19);
    if (*((unsigned char *)t10) != *((unsigned char *)t17))
        goto LAB52;

LAB56:    t19 = (t19 + 1);
    goto LAB54;

LAB57:    t26 = 0;

LAB60:    if (t26 < 3U)
        goto LAB61;
    else
        goto LAB59;

LAB61:    t23 = (t21 + t26);
    t24 = (t20 + t26);
    if (*((unsigned char *)t23) != *((unsigned char *)t24))
        goto LAB58;

LAB62:    t26 = (t26 + 1);
    goto LAB60;

LAB63:    xsi_set_current_line(68, ng0);
    t27 = (t0 + 6149);
    t29 = (t0 + 4032);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    memcpy(t33, t27, 2U);
    xsi_driver_first_trans_fast_port(t29);
    goto LAB11;

LAB65:    t20 = (t0 + 1672U);
    t21 = *((char **)t20);
    t20 = (t0 + 6146);
    t13 = 1;
    if (3U == 3U)
        goto LAB83;

LAB84:    t13 = 0;

LAB85:    t3 = t13;
    goto LAB67;

LAB68:    t7 = (t0 + 1512U);
    t8 = *((char **)t7);
    t7 = (t0 + 6142);
    t12 = 1;
    if (4U == 4U)
        goto LAB77;

LAB78:    t12 = 0;

LAB79:    t4 = (!(t12));
    goto LAB70;

LAB71:    t16 = 0;

LAB74:    if (t16 < 4U)
        goto LAB75;
    else
        goto LAB73;

LAB75:    t1 = (t2 + t16);
    t6 = (t5 + t16);
    if (*((unsigned char *)t1) != *((unsigned char *)t6))
        goto LAB72;

LAB76:    t16 = (t16 + 1);
    goto LAB74;

LAB77:    t19 = 0;

LAB80:    if (t19 < 4U)
        goto LAB81;
    else
        goto LAB79;

LAB81:    t10 = (t8 + t19);
    t17 = (t7 + t19);
    if (*((unsigned char *)t10) != *((unsigned char *)t17))
        goto LAB78;

LAB82:    t19 = (t19 + 1);
    goto LAB80;

LAB83:    t26 = 0;

LAB86:    if (t26 < 3U)
        goto LAB87;
    else
        goto LAB85;

LAB87:    t23 = (t21 + t26);
    t24 = (t20 + t26);
    if (*((unsigned char *)t23) != *((unsigned char *)t24))
        goto LAB84;

LAB88:    t26 = (t26 + 1);
    goto LAB86;

LAB89:    xsi_set_current_line(70, ng0);
    t27 = (t0 + 6158);
    t29 = (t0 + 4032);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    memcpy(t33, t27, 2U);
    xsi_driver_first_trans_fast_port(t29);
    goto LAB11;

LAB91:    t20 = (t0 + 1672U);
    t21 = *((char **)t20);
    t20 = (t0 + 6155);
    t13 = 1;
    if (3U == 3U)
        goto LAB109;

LAB110:    t13 = 0;

LAB111:    t3 = t13;
    goto LAB93;

LAB94:    t7 = (t0 + 1512U);
    t8 = *((char **)t7);
    t7 = (t0 + 6151);
    t12 = 1;
    if (4U == 4U)
        goto LAB103;

LAB104:    t12 = 0;

LAB105:    t4 = (!(t12));
    goto LAB96;

LAB97:    t16 = 0;

LAB100:    if (t16 < 4U)
        goto LAB101;
    else
        goto LAB99;

LAB101:    t1 = (t2 + t16);
    t6 = (t5 + t16);
    if (*((unsigned char *)t1) != *((unsigned char *)t6))
        goto LAB98;

LAB102:    t16 = (t16 + 1);
    goto LAB100;

LAB103:    t19 = 0;

LAB106:    if (t19 < 4U)
        goto LAB107;
    else
        goto LAB105;

LAB107:    t10 = (t8 + t19);
    t17 = (t7 + t19);
    if (*((unsigned char *)t10) != *((unsigned char *)t17))
        goto LAB104;

LAB108:    t19 = (t19 + 1);
    goto LAB106;

LAB109:    t26 = 0;

LAB112:    if (t26 < 3U)
        goto LAB113;
    else
        goto LAB111;

LAB113:    t23 = (t21 + t26);
    t24 = (t20 + t26);
    if (*((unsigned char *)t23) != *((unsigned char *)t24))
        goto LAB110;

LAB114:    t26 = (t26 + 1);
    goto LAB112;

LAB115:    xsi_set_current_line(76, ng0);
    t27 = (t0 + 6169);
    t29 = (t0 + 4096);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    memcpy(t33, t27, 2U);
    xsi_driver_first_trans_fast_port(t29);
    goto LAB116;

LAB118:    t20 = (t0 + 1832U);
    t21 = *((char **)t20);
    t20 = (t0 + 6166);
    t13 = 1;
    if (3U == 3U)
        goto LAB136;

LAB137:    t13 = 0;

LAB138:    t3 = t13;
    goto LAB120;

LAB121:    t7 = (t0 + 1512U);
    t8 = *((char **)t7);
    t7 = (t0 + 6162);
    t12 = 1;
    if (4U == 4U)
        goto LAB130;

LAB131:    t12 = 0;

LAB132:    t4 = (!(t12));
    goto LAB123;

LAB124:    t16 = 0;

LAB127:    if (t16 < 4U)
        goto LAB128;
    else
        goto LAB126;

LAB128:    t1 = (t2 + t16);
    t6 = (t5 + t16);
    if (*((unsigned char *)t1) != *((unsigned char *)t6))
        goto LAB125;

LAB129:    t16 = (t16 + 1);
    goto LAB127;

LAB130:    t19 = 0;

LAB133:    if (t19 < 4U)
        goto LAB134;
    else
        goto LAB132;

LAB134:    t10 = (t8 + t19);
    t17 = (t7 + t19);
    if (*((unsigned char *)t10) != *((unsigned char *)t17))
        goto LAB131;

LAB135:    t19 = (t19 + 1);
    goto LAB133;

LAB136:    t26 = 0;

LAB139:    if (t26 < 3U)
        goto LAB140;
    else
        goto LAB138;

LAB140:    t23 = (t21 + t26);
    t24 = (t20 + t26);
    if (*((unsigned char *)t23) != *((unsigned char *)t24))
        goto LAB137;

LAB141:    t26 = (t26 + 1);
    goto LAB139;

LAB142:    xsi_set_current_line(78, ng0);
    t27 = (t0 + 6178);
    t29 = (t0 + 4096);
    t30 = (t29 + 56U);
    t31 = *((char **)t30);
    t32 = (t31 + 56U);
    t33 = *((char **)t32);
    memcpy(t33, t27, 2U);
    xsi_driver_first_trans_fast_port(t29);
    goto LAB116;

LAB144:    t20 = (t0 + 1832U);
    t21 = *((char **)t20);
    t20 = (t0 + 6175);
    t13 = 1;
    if (3U == 3U)
        goto LAB162;

LAB163:    t13 = 0;

LAB164:    t3 = t13;
    goto LAB146;

LAB147:    t7 = (t0 + 1512U);
    t8 = *((char **)t7);
    t7 = (t0 + 6171);
    t12 = 1;
    if (4U == 4U)
        goto LAB156;

LAB157:    t12 = 0;

LAB158:    t4 = (!(t12));
    goto LAB149;

LAB150:    t16 = 0;

LAB153:    if (t16 < 4U)
        goto LAB154;
    else
        goto LAB152;

LAB154:    t1 = (t2 + t16);
    t6 = (t5 + t16);
    if (*((unsigned char *)t1) != *((unsigned char *)t6))
        goto LAB151;

LAB155:    t16 = (t16 + 1);
    goto LAB153;

LAB156:    t19 = 0;

LAB159:    if (t19 < 4U)
        goto LAB160;
    else
        goto LAB158;

LAB160:    t10 = (t8 + t19);
    t17 = (t7 + t19);
    if (*((unsigned char *)t10) != *((unsigned char *)t17))
        goto LAB157;

LAB161:    t19 = (t19 + 1);
    goto LAB159;

LAB162:    t26 = 0;

LAB165:    if (t26 < 3U)
        goto LAB166;
    else
        goto LAB164;

LAB166:    t23 = (t21 + t26);
    t24 = (t20 + t26);
    if (*((unsigned char *)t23) != *((unsigned char *)t24))
        goto LAB163;

LAB167:    t26 = (t26 + 1);
    goto LAB165;

}


extern void work_a_3946787226_3212880686_init()
{
	static char *pe[] = {(void *)work_a_3946787226_3212880686_p_0};
	xsi_register_didat("work_a_3946787226_3212880686", "isim/test8_isim_beh.exe.sim/work/a_3946787226_3212880686.didat");
	xsi_register_executes(pe);
}
