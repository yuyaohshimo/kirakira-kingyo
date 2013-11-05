package fish.collection.json
{
	/**
	 * 外部コンフィグ 
	 * @author A13201
	 * 
	 */	
	public class ExternalConfig
	{
		public function ExternalConfig()
		{
		}
		
		// 外部コンフィグJSONを使用するかどうかフラグ
		public static const IS_USE_EXTERNAL_JSON:Boolean = false; 
		
		public static const scorelist:Object = {
			type1: {
				normal: 100
			},
			type2: {
				normal: 200
			},
			type3: {
				normal: 300
			},
			type4: {
				normal: 400
			},
			type5: {
				normal: 500
			},
			type6: {
				normal: 600
			}
		};
		
		public static const config:Object = {
			uri: 'ws://localhost:8888',
			origin: '*',
			protocol: 'lws-mirror-protocol'
		};
			
		public static var sendfish:Object = {
			id: 'game.fish',
			data: {
				t_id: undefined,
				fishInfo: {
					size: undefined,
					score: undefined,
					parts: {
						head: undefined,
						body: undefined,
						lFill: undefined,
						rFill: undefined,
						tail: undefined
					}
				}
			}
		};
	}
}