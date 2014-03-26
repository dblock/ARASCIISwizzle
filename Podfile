workspace 'ARASCIISwizzle'

pod 'ARASCIISwizzle', :path => 'ARASCIISwizzle.podspec'

xcodeproj 'Demo.xcodeproj'

target 'Demo' do
  pod 'FLKAutoLayout', '~> 0.1.1'
  xcodeproj 'Demo.xcodeproj'
end

target 'IntegrationTests' do
  pod 'Specta', '~> 0.2.1'
  pod 'Expecta', '~> 0.2.3'
  pod 'FBSnapshotTestCase', :head
  pod 'EXPMatchers+FBSnapshotTest', :head
  xcodeproj 'Demo.xcodeproj'
end

target 'Tests' do
  pod 'Specta', '~> 0.2.1'
  pod 'Expecta', '~> 0.2.3'
  pod 'FBSnapshotTestCase', :head
  pod 'EXPMatchers+FBSnapshotTest', :head
  pod 'OCMock', '~> 2.2.3'
  xcodeproj 'Tests.xcodeproj'
end
