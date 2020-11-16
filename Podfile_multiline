source 'https://cdn.cocoapods.org/'

platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

target 'App' do

  pod 'Pod1',
    :git => 'https://git.com/pod1',
    :branch => 'develop',
    :inhibit_warnings => false
  pod 'Pod2',
    :git => 'https://git.com/pod2',
    :branch => 'develop',
    :inhibit_warnings => false
  pod 'Pod3',
    :git => 'https://git.com/pod3',
    :branch => 'develop',
    :inhibit_warnings => false

  target 'AppTests' do
    inherit! :search_paths

    pod 'PodTest1',
      :git => 'https://git.com/podTest1',
      :branch => 'develop',
      :inhibit_warnings => false
    pod 'PodTest2',
      :git => 'https://git.com/podTest2',
      :branch => 'develop',
      :inhibit_warnings => false
    pod 'PodTest3',
      :git => 'https://git.com/podTest3',
      :branch => 'develop',
      :inhibit_warnings => false
  end
end
