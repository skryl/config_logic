# Config Logic

Config Logic is a configuration management tool for Ruby/Rails applications. It
wraps any set of config files in a managed access layer which supports

* caching
* multi argument, hash style, or dot style access
* ordered overlays
* dynamic or static multiplexing


## Requirements

The following gems will be installed along with config_logic

* activesupport (2.2.2+)
* buffered_logger (0.1.2+)


## Installation

    gem install config_logic


## Usage

Imagine that your application has a config directory with the following layout,

    config/config_prod.yml -->

        :key1: 1 
        :key2: 2
        :key3: 3

    config/config_dev.yml -->

        :key1: 11 
        :key2: 12 
        :key3: 13

    config/dir1/config_prod.yml -->
        
        :key1: 11 
        :key2: 12 
        :key3: 13

    config/dir1/config_dev.yml -->

        :key4: 1
        :key5: 2
        :key6: 3


### Initialization

    c = ConfigLogic.new('path/to/config/dir')
    c = ConfigLogic.new(['path1', 'path2'])


### Data Access

    c.config.key1        => 1
    c[:config][:key1]    => 1
    c['config']['key1']  => 1
    c(:config, :key1)    => 1
    c('config', 'key1')  => 1
    c.unknown            => nil
    c.config.unknown     => nil


### Rebuilding the Config Cache

    c.reload!


### Applying Overlays

An Overlay allows multiple config values to be merged in a specified order. The
merge order is determined by the order of the key names in the :inputs parameter.

#### Global

    c = ConfigLogic.new('path/to/config/dir', :overlays => [ { :name => 'config',
                                                               :inputs => [:config_prod, :config_dev] } ] )
    c.config.key1 => 11
    c.config.key2 => 12
    c.config.key3 => 13
    c.config.dir1.key1 => 11
    c.config.dir1.key2 => 12
    c.config.dir1.key3 => 13
    c.config.dir1.key4 => 1
    c.config.dir1.key5 => 2
    c.config.dir1.key6 => 3

#### Local

    c.config.insert_overlay( { :name => 'config',
                               :inputs => [:config_prod, :config_dev] } )
    c.config.key1 => 11
    c.config.key2 => 12
    c.config.key3 => 13
    c.config.dir1.key1 => 1
    c.config.dir1.key2 => 2
    c.config.dir1.key3 => 3
    c.config.dir1.key4 => nil


### Applying Multiplexers

A multiplexer groups multiple config values and uses the result of a supplied code
block to choose the appropriate one. Multiplexers can be static or dynamic. A
static multiplexer is evaluated when it is created and its result replaces the
key group specified. A dynamic multiplexer is evaluated every time it's called.
Multiplexers are static by default.
 

#### Global

    c = ConfigLogic.new('path/to/config/dir', :multiplexers => [ { :name => 'key',
                                                                   :selector => Proc.new {1 + 1 },
                                                                   :inputs => {1 => :key1, 2 => :key2, 3 => :key3} } ] )
    c.config.key => 2
    c.config.key1 => nil
    c.config.key2 => nil
    c.config.key3 => nil
    c.config.dir1.key => 2
    c.config.dir1.key1 => nil
    c.config.dir1.key2 => nil
    c.config.dir1.key3 => nil

#### Local

    c.config.insert_multiplexer({ :name => 'key',
                                  :selector => Proc.new {1 + 1 },
                                  :inputs => {1 => :key1, 2 => :key2, 3 => :key3} })
    c.config.key => 2
    c.config.key1 => nil
    c.config.key2 => nil
    c.config.key3 => nil
    c.config.dir1.key => nil
    c.config.dir1.key1 => 1
    c.config.dir1.key2 => 2
    c.config.dir1.key3 => 3

#### Static vs Dynamic

A dynamic multiplexer will re-evaluate the selecor proc every time it's called

    c.config.insert_multiplexer({ :name => 'key',
                                  :static => false,
                                  :selector => Proc.new { rand(3) + 1 },
                                  :inputs => {1 => :key1, 2 => :key2, 3 => :key3} })
    c.config.key => 2 = time = 0
    c.config.key => 1 = time = 0 + n
  

## Credits

Inspired by RConfig (Rahmal Conda) / activeconfig (Enova Financial)
