//
//  SynthesizeSingleton.h
//  CocoaWithLove
//
//  Created by Matt Gallagher on 20/10/08.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//
//  Permission is given to use this source code file, free of charge, in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

// Edited on 09/06/2010 to give the option to name the singleton instance
#define SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_INSTANCE(classname, singletonInstanceName) \
\
static classname *shared##singletonInstanceName = nil; \
\
+ (classname *)shared##singletonInstanceName \
{ \
@synchronized(self) \
{ \
if (shared##singletonInstanceName == nil) \
{ \
shared##singletonInstanceName = [[self alloc] init]; \
} \
} \
\
return shared##singletonInstanceName; \
} \
\
+ (id)allocWithZone:(NSZone *)zone \
{ \
@synchronized(self) \
{ \
if (shared##singletonInstanceName == nil) \
{ \
shared##singletonInstanceName = [super allocWithZone:zone]; \
return shared##singletonInstanceName; \
} \
} \
\
return nil; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return self; \
} \
\
- (id)retain \
{ \
return self; \
} \
\
- (NSUInteger)retainCount \
{ \
return NSUIntegerMax; \
} \
\
- (void)release \
{ \
} \
\
- (id)autorelease \
{ \
return self; \
} 

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_INSTANCE(classname, classname)
