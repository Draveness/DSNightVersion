class ObjcClass
	attr_accessor :name
	attr_accessor :properties
	def initialize(name)
		@name = name
		@properties = []
	end

	def file_name(property)
		s = "#{name}+#{property.cap_name}"
	end

    def interface_class_string(property)
		s = <<H
//
//  #{name}+#{property.cap_name}.h
//  #{name}+#{property.cap_name}
//
//  Created by apple on 4/14/15.
//  Copyright (c) 2015 Draveness. All rights reserved.

#{interface_import_string}

#{interface_string(property)}
#{interface_property_string(property)}
@end
H
	end

	def implementation_class_string(property)
		s = <<H
//
//  #{name}+#{property.cap_name}.m
//  #{name}+#{property.cap_name}
//
//  Created by apple on 4/14/15.
//  Copyright (c) 2015 Draveness. All rights reserved.

#{implementation_import_string(property)}
#{implementation_interface_string(property)}
#{implementation_string(property)}
H
	end

private

	def interface_import_string
		"#import <UIKit/UIKit.h>"
	end

	def interface_string(property)
		s = <<H
@interface #{name} (#{property.cap_name})
H
	end

	def interface_property_string(property)
		s = <<H
/**
 Set this property when switch to night version #{name[2..-1].downcase} #{property.name.downcase} turns to this color.
*/
@property (nonatomic, strong) #{property.type} *night#{property.cap_name};

/**
 #{name[2..-1].capitalize} #{property.name.downcase} in normal version.
*/
@property (nonatomic, strong, readonly) #{property.type} *normal#{property.cap_name};

H
	end


	def implementation_import_string(property)
		s = <<H
#import \"#{name}+#{property.name}.h\"
#import \"objc/runtime.h\"
H
	end

	def implementation_interface_string(property)
		s = <<H
@interface #{name} ()

@property (nonatomic, strong) #{property.type} *normal#{property.cap_name};

@end
H
	end

	def implementation_static_char_string(property)
		s = <<H
static char *night#{property.name}Key;
static char *normal#{property.name}Key;
H
	end

	def implementation_string(property)
		s = <<H
@implementation #{name} (#{property.cap_name})

#{implementation_static_char_string(property)}
#{property.method_string}
@end
H
	end

end

# p = Property.new("backgroundColor")
# c = Class.new("UIView")
# # puts p.method_string
# puts c.implement_class_string(p)
# puts c.interface_class_string(p)
