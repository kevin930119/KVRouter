Pod::Spec.new do |s|
s.name         = 'KVRouter'
s.version      = '1.0.0'
s.summary      = '这是一个iOS界面解耦神器'
s.homepage     = 'https://github.com/kevin930119/KVRouter'
s.license      = 'MIT'
s.authors      = {'Kevin' => '673729631@qq.com'}
s.platform     = :ios, '7.0'
s.source       = {:git => 'https://github.com/kevin930119/KVRouter.git', :tag => s.version}
s.source_files = 'KVRouter/*'
s.requires_arc = true
end
