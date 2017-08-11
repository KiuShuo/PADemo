platform :ios, '8.0'

#targetsArray = ['PANotificationService', 'PANotificationContent']
#
#targetsArray.each do |t|
#    target t do
#        use_frameworks!
#        
#    end
#end


target 'PADemo' do
    inhibit_all_warnings!
    use_frameworks!
    $WJFrameworkUrl = 'svn://172.19.21.212/wanjia/src/yidong/IOS/WJFramework/'
    pod 'WJExtension', :svn => $WJFrameworkUrl +'WJExtension', :tag => '1.0.8'
    pod 'SDWebImage', '3.7.5'
    pod 'Masonry', '1.0.2'
    pod 'ObjectMapper', '2.2.5'
    pod 'HexColors','2.3.0'
    pod 'IQKeyboardManager', '3.3.7'
    pod 'EBForeNotification', '1.0.7'
    #    pod 'UITableView+FDTemplateLayoutCell', '1.6'
    # https://github.com/forkingdog/UITableView-FDTemplateLayoutCell.git
    pod 'UITableView+FDTemplateLayoutCell', :git => 'https://github.com/forkingdog/UITableView-FDTemplateLayoutCell.git', :branch => 'master'
    pod 'IGListKit', :git => 'https://github.com/Instagram/IGListKit.git', :branch => 'master'
    pod 'Fabric', '1.6.11'
    pod 'Crashlytics', '3.8.4'
    pod 'RxSwift', '3.5.0'
    pod 'HJTabViewController', '~> 1.0'
    
end

