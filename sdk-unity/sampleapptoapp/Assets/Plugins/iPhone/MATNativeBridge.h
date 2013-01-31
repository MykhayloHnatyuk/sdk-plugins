#import <Foundation/Foundation.h>
#import <MobileAppTracker/MobileAppTracker.h>
#import <string>
#import <map>

typedef struct MATEventItem
{
    const char* item;
	double 		unitPrice;
	int         quantity;
	double		revenue;
} MATEventItem;