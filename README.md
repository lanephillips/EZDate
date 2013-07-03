EZDate
======

EZDate is a convenient wrapper for NSDate that does everything you thought NSDate should do, but were surprised it didn't. It includes a calendar and a time zone, so you can perform all kinds of common date operations with less typing. EZDate inherits from NSDate, so you can drop it in wherever you used NSDate.

Creating an EZDate
------------------

All the factory methods from NSDate have been overridden to return an EZDate:

	+ (id)date;
	
	+ (id)dateWithTimeIntervalSinceNow:(NSTimeInterval)secs;
	+ (id)dateWithTimeIntervalSinceReferenceDate:(NSTimeInterval)secs;
	+ (id)dateWithTimeIntervalSince1970:(NSTimeInterval)secs;
	+ (id)dateWithTimeInterval:(NSTimeInterval)ti sinceDate:(NSDate *)date;
	
	+ (id)distantFuture;
	+ (id)distantPast;
  
All of NSDate's init methods are available, too:

	- (id)init;
	- (id)initWithTimeIntervalSinceNow:(NSTimeInterval)secs;
	- (id)initWithTimeIntervalSinceReferenceDate:(NSTimeInterval)secsToBeAdded;
	- (id)initWithTimeIntervalSince1970:(NSTimeInterval)ti;
	- (id)initWithTimeInterval:(NSTimeInterval)secsToBeAdded sinceDate:(NSDate *)anotherDate;

Of course, you can create an EZDate from an existing NSDate:

	+ (id)dateWithNSDate:(NSDate*)date;
	- (id)initWithNSDate:(NSDate*)date;

By default, EZDate uses the Gregorian calendar and the system default time zone, but you can replace these:

	+ (id)dateWithNSDate:(NSDate*)date calendarIdentifier:(NSString*)calendar timeZone:(NSTimeZone*)tz;
	- (id)initWithNSDate:(NSDate*)date calendarIdentifier:(NSString*)calendar timeZone:(NSTimeZone*)tz;

Accessing Date Components
-------------------------
	@property (nonatomic,readonly) NSInteger year;
	@property (nonatomic,readonly) NSInteger month;
	@property (nonatomic,readonly) NSInteger day;
	@property (nonatomic,readonly) NSInteger hour;
	@property (nonatomic,readonly) NSInteger minute;
	@property (nonatomic,readonly) NSInteger second;
	
	// less common
	@property (nonatomic,readonly) NSInteger era;
	@property (nonatomic,readonly) NSInteger week;
	@property (nonatomic,readonly) NSInteger weekday;
	@property (nonatomic,readonly) NSInteger weekdayOrdinal;
	@property (nonatomic,readonly) NSInteger weekOfMonth;
	@property (nonatomic,readonly) NSInteger weekOfYear;
	@property (nonatomic,readonly) NSInteger yearForWeekOfYear;


	+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
	+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
	// HMS today
	+ (id)dateWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
	// e.g. first Wednesday of the month
	+ (id)dateWithYear:(NSInteger)year month:(NSInteger)month ordinal:(NSInteger)ordinal weekday:(NSInteger)weekday;

Date Arithmetic
---------------
	- (id)dateByAddingYears:(NSInteger)years months:(NSInteger)months days:(NSInteger)days;
	- (id)dateByAddingHours:(NSInteger)hours minutes:(NSInteger)minutes seconds:(NSInteger)seconds;
	
	// overridden to return EZDate
	- (id)dateByAddingTimeInterval:(NSTimeInterval)ti;
	
	// date at next occurrence after the receiver, useful for setting alarms not in the past
	- (id)dateAtNextOccurrenceOfWeekday:(NSInteger)weekday;
	- (id)dateAtNextOccurrenceOfMonth:(NSInteger)month day:(NSInteger)day;
	- (id)dateAtNextOccurrenceOfHour:(NSInteger)hour minute:(NSInteger)minute;

Date Formatting
---------------
	// overridden to guarantee "yyyy-MM-dd HH:mm:ss Z" format
	- (NSString *)description;
	
	// subscript with a format string to get the formatted date string, e.g. NSString* formatted = aDate[@"yyyy-MM-dd"];
	- (id)objectForKeyedSubscript:(id)key;
	// if you think that's a hack you can use this
	- (NSString*)stringWithDateFormat:(NSString*)format;
	
	// get a nice-looking date or time string suitable for an email or RSS app
	// returns time if today, month and day if within the last year,
	// full date if in the future or more than a year ago
	- (NSString*)prettyString;
	
	// return a human-friendly elapsed time similar to the Twitter app
	// e.g 4m, 6h, 23d, 1y
	// positive value regardless of future or past
	- (NSString*)prettyElapsedTimeString;

Repeating Dates
---------------
	// enumerators for various calendar applications, basically every repeat option offered by Google Calendar
	// the argument to the first block call is the receiver
	// set stop to YES to exit enumeration
	- (void)repeatEvery:(NSInteger)days daysEndingAt:(NSDate*)end usingBlock:(void(^)(EZDate* date, BOOL *stop))block;
	- (void)repeatEvery:(NSInteger)days daysEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void(^)(EZDate* date, BOOL *stop))block;
	- (void)repeatEvery:(NSInteger)weeks weeksOnWeekdays:(EZWeekdayMask)mask endingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block;
	- (void)repeatEvery:(NSInteger)weeks weeksOnWeekdays:(EZWeekdayMask)mask endingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block;
	- (void)repeatEvery:(NSInteger)months monthsEndingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block;
	- (void)repeatEvery:(NSInteger)months monthsEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block;
	- (void)repeatOrdinalEvery:(NSInteger)months monthsEndingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block;
	- (void)repeatOrdinalEvery:(NSInteger)months monthsEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block;
	- (void)repeatEvery:(NSInteger)years yearsEndingAt:(NSDate*)end usingBlock:(void (^)(EZDate *date, BOOL *stop))block;
	- (void)repeatEvery:(NSInteger)years yearsEndingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void (^)(EZDate *date, BOOL *stop))block;
	
	// what implements most of the above
	- (void)repeatByAddingComponents:(NSDateComponents*)comps endingAt:(NSDate*)end usingBlock:(void(^)(EZDate* date, BOOL *stop))block;
	- (void)repeatByAddingComponents:(NSDateComponents*)comps endingAfter:(NSInteger)occurrences occurrencesUsingBlock:(void(^)(EZDate* date, BOOL *stop))block;
