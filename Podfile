platform :ios, '8.0'


targetsArray = ['PANotificationService', 'PANotificationContent']

targetsArray.each do |t|
    target t do
        use_frameworks!
        pod 'SDWebImage', '3.7.5'
        end
    end


target 'PADemo' do
    inhibit_all_warnings!
    use_frameworks!
    $WJFrameworkUrl = 'svn://172.19.21.212/wanjia/src/yidong/IOS/WJFramework/'
    pod 'WJExtension', :svn => $WJFrameworkUrl +'WJExtension', :tag => '1.0.8'
    pod 'SDWebImage', '3.7.5'
    pod 'Masonry', '~> 1.0.2'
    pod 'ObjectMapper', '~> 2.2.5'
    pod 'HexColors','2.3.0'
    pod 'IQKeyboardManager', '3.3.7'
    end

