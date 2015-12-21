package baseGameEntity.entityFunctionTemplates
{
	import vector.Vector2d;

	public class EntityFunctionTemplates
	{
		public function EntityFunctionTemplates()
		{
			
		}
		
		public static function EnforceNonPenetrationConstraint(stEntity:*,szContainerEntities:*):void
		{
			var iLn:int = szContainerEntities.length;
			var nDis:Number;
			var nStDis:Number;
			var stTo:Vector2d;
			var nBRDis:Number;
			for(var i:int = 0;i<iLn&&szContainerEntities[i]!=null;++i)
			{
				if(szContainerEntities[i]==stEntity)
					continue;
				stTo = szContainerEntities[i].Pos.SubVectorRet(stEntity.Pos);
				nDis = stEntity.BRadius+szContainerEntities[i].BRadius;
				nStDis = stTo.Length();
				if(nStDis<nDis)
				{
					nBRDis = nDis - nStDis;
					szContainerEntities[i].Pos.AddVector(Vector2d.Vect2DNormalize(stTo).MulNumberRet(nBRDis));
				}
			}
		
		}
		
	}
}