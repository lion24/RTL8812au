/******************************************************************************
 *
 * Copyright(c) 2007 - 2011 Realtek Corporation. All rights reserved.
 *                                        
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of version 2 of the GNU General Public License as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * this program; if not, write to the Free Software Foundation, Inc.,
 * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
 *
 *
 ******************************************************************************/
 
#ifndef	__PHYDMEDCATURBOCHECK_H__
#define    __PHYDMEDCATURBOCHECK_H__

#define EDCATURBO_VERSION	"1.0"

typedef struct _EDCA_TURBO_
{
	BOOLEAN bCurrentTurboEDCA;
	BOOLEAN bIsCurRDLState;

	#if(DM_ODM_SUPPORT_TYPE == ODM_CE	)
	u4Byte	prv_traffic_idx; // edca turbo
	#endif

}EDCA_T,*pEDCA_T;


#if(DM_ODM_SUPPORT_TYPE & (ODM_AP|ODM_ADSL))
enum qos_prio { BK, BE, VI, VO, VI_AG, VO_AG };

static const struct ParaRecord rtl_ap_EDCA[] =
{
//ACM,AIFSN, ECWmin, ECWmax, TXOplimit
     {0,     7,      4,      10,     0},            //BK
     {0,     3,      4,      6,      0},             //BE
     {0,     1,      3,      4,      188},         //VI
     {0,     1,      2,      3,      102},         //VO
     {0,     1,      3,      4,      94},          //VI_AG
     {0,     1,      2,      3,      47},          //VO_AG
};

static const struct ParaRecord rtl_sta_EDCA[] =
{
//ACM,AIFSN, ECWmin, ECWmax, TXOplimit
     {0,     7,      4,      10,     0},
     {0,     3,      4,      10,     0},
     {0,     2,      3,      4,      188},
     {0,     2,      2,      3,      102},
     {0,     2,      3,      4,      94},
     {0,     2,      2,      3,      47},
};
#endif

#if(DM_ODM_SUPPORT_TYPE & (ODM_AP|ODM_ADSL))
#ifdef WIFI_WMM
VOID
ODM_IotEdcaSwitch(
	IN		PVOID					pDM_VOID,
	IN	unsigned char		enable
	);
#endif

BOOLEAN
ODM_ChooseIotMainSTA(
	IN		PVOID					pDM_VOID,
	IN	PSTA_INFO_T		pstat
	);
#endif

VOID
odm_EdcaTurboCheck(
	IN 	PVOID	 	pDM_VOID
	);
VOID
ODM_EdcaTurboInit(
	IN 	PVOID	 	pDM_VOID
);

#if(DM_ODM_SUPPORT_TYPE==ODM_WIN)
VOID
odm_EdcaTurboCheckMP(
	IN 	PVOID	 	pDM_VOID
	);

//check if edca turbo is disabled
BOOLEAN
odm_IsEdcaTurboDisable(
	IN 	PVOID	 	pDM_VOID
);
//choose edca paramter for special IOT case
VOID 
ODM_EdcaParaSelByIot(
	IN		PVOID					pDM_VOID,
	OUT	u4Byte		*EDCA_BE_UL,
	OUT u4Byte		*EDCA_BE_DL
	);
//check if it is UL or DL
VOID
odm_EdcaChooseTrafficIdx( 
	IN 	PVOID	 	pDM_VOID,
	IN	u8Byte  			cur_tx_bytes,  
	IN	u8Byte  			cur_rx_bytes, 
	IN	BOOLEAN 		bBiasOnRx,
	OUT BOOLEAN 		*pbIsCurRDLState
	);

#elif (DM_ODM_SUPPORT_TYPE==ODM_CE)
VOID
odm_EdcaTurboCheckCE(
	IN 	PVOID	 	pDM_VOID
	);
#else
VOID 
odm_IotEngine(
	IN 	PVOID	 	pDM_VOID
	);

VOID
odm_EdcaParaInit(
	IN 	PVOID	 	pDM_VOID
	);
#endif

#endif
