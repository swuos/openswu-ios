//
//  Router.h
//  SwuAssistant
//
//  Created by ShockHsu on 16/1/21.
//  Copyright © 2016年 OpenSource Association of SWU. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol refresh <NSObject>

- (void)refreshWithDict:(NSArray *)dict;

@end


@interface Router : NSObject

@property (nonatomic, weak) id<refresh> delegate;

+ (Router *)sharedInstance;

- (void)loginWithName:(NSString *)name AndPassword:(NSString *)password AndCompletionHandler:(void (^)(NSString *))blockName;

- (void)getGrades;

@end

/*
 
 
 
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "94",
 "jd": "4.4",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-21210680-20062997-1",
 "kch": "21210680",
 "kcmc": "离散数学",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "4.0",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "items": [
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "60",
 "jd": "1",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-00120893",
 "kch": "00120893",
 "kcmc": "名著阅读",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "2.0",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "82",
 "cjbz": "含弘在线",
 "jd": "3.3",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-00120906",
 "kch": "00120906",
 "kcmc": "国际投资(网络)",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "2",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "4",
 "cjbz": "超星",
 "jd": "0",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-00120924",
 "kch": "00120924",
 "kcmc": "从爱因斯坦到霍金的宇宙(网络)",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "2.0",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "72",
 "jd": "2.2",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-21210142-20070241-1",
 "kch": "21210142",
 "kcmc": "高等数学ⅠB",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "5.0",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "78",
 "jd": "2.8",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-21210200-20054890-1",
 "kch": "21210200",
 "kcmc": "线性代数Ⅰ",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "3.0",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "87",
 "jd": "3.7",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-212106601-20054326-1",
 "kch": "212106601",
 "kcmc": "C语言程序设计",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "4.5",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "94",
 "jd": "4.4",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-21210680-20062997-1",
 "kch": "21210680",
 "kcmc": "离散数学",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "4.0",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "80",
 "jd": "3",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-21213200-20060010-1",
 "kch": "21213200",
 "kcmc": "电路分析（电工基础）",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "3.0",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "95",
 "jd": "4.5",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-21322852-20054889-1",
 "kch": "21322852",
 "kcmc": "Linux环境实践",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "2.0",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 },
 {
 "bh_id": "2014211001",
 "bj": "14计科01班",
 "cj": "90",
 "jd": "4",
 "jgmc": "计算机与信息科学学院、软件学院",
 "jgpxzd": "1",
 "jxb_id": "14-2015-2)-21324150-20054527-1",
 "kch": "21324150",
 "kcmc": "C语言综合课程设计",
 "listnav": "false",
 "njdm_id": "2014",
 "njmc": "2014",
 "pageable": true,
 "queryModel": {
 "currentPage": 1,
 "currentResult": 0,
 "entityOrField": false,
 "showCount": 10,
 "totalPage": 0,
 "totalResult": 0
 },
 "rangeable": true,
 "totalResult": "36",
 "xb": "男",
 "xf": "2.0",
 "xh": "222014321210009",
 "xm": "徐小康",
 "xnmmc": "2014-2015",
 "xqmmc": "2",
 "zyh_id": "2110",
 "zymc": "计算机科学与技术"
 }
 ],
 "showCount": 10,
 "totalPage": 4,
 "totalResult": 36
 }
 */
